# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module IbmcCookbook
  class BaseResource < Chef::Resource
    property :ibmc_host, String, desired_state: false
    property :ibmc_port, Integer, default: 443, desired_state: false
    property :ibmc_username, String, desired_state: false
    property :ibmc_password, String, sensitive: true, desired_state: false

    resource_name :ibmc_base
    default_action :default

    action :default do
      log 'Please specify action'
    end

    # Enviroment flag
    @@is_dev = false

    load_current_value do
      @@is_dev = ignore_exception(false) do
        is_dev = node['ibmc']['is_dev']
        # Only `true` and `false` are valid options
        (!!is_dev == is_dev) && is_dev
      end

      # First, load ibmc data from attributes if not set in recipe
      ibmc = ignore_exception(nil) do
        node['ibmc']['main']
      end
      # Chef::Log.debug("attribute default['ibmc']['main']: #{ibmc}")
      load_ibmc_properties(ibmc) if ibmc && !ibmc.empty?

      # Second, load ibmc data from data bag if not found in attributes
      ibmc = ignore_exception(nil) do
        data_bag_item('ibmc', 'main')
      end unless ibmc_properties_is_set?
      # Chef::Log.debug("data_bag_item('ibmc', 'main'): #{ibmc}")
      load_ibmc_properties(ibmc) if ibmc && !ibmc.empty?

      # Last, check properties
      ibmc_properties_is_set?(true)
    end

    action_class do
      # Copy urest files to `/opt/uREST`, if the files does not exists.
      def copy_urest
        ## For disable command line output, use shell_out! instead of `execute` resource
        ## script logic
        # mkdir -p #{IbmcCookbook::Const::DIR_UREST}

        # NEW_FILE=#{new_file}
        # OLD_FILE=#{old_file}

        # NEW_MD5=$(md5sum $NEW_FILE | cut -d' ' -f1)
        # OLD_MD5=$(md5sum $OLD_FILE | cut -d' ' -f1)

        # if [[ $NEW_MD5 != $OLD_MD5 ]]
        # then
        #     cp $NEW_FILE $OLD_FILE
        #     cd $(dirname $OLD_FILE)
        #     tar -zxf uREST.tar.gz
        #     chmod 0755 bin/rest
        # fi
        new_file = "#{Chef::Config[:cookbook_path]}/chef-ibmc-cookbook/files/default/uREST.tar.gz"
        old_file = IbmcCookbook::Const::PATH_UREST_TAR
        shell_out!("mkdir -p #{IbmcCookbook::Const::DIR_UREST}")
        new_md5 = Mixlib::ShellOut.new("md5sum #{new_file} | cut -d' ' -f1")
        old_md5 = Mixlib::ShellOut.new("md5sum #{old_file} | cut -d ' ' -f1")
        unless new_md5 == old_md5
          shell_out!("cp #{new_file} #{old_file}")
          shell_out!("cd $(dirname #{old_file}) && tar -zxf uREST.tar.gz && chmod 0755 bin/rest")
        end
      end

      def build_cmd_str
        program = @@is_dev ? 'echo' : './rest'
        "#{program} -H #{current_resource.ibmc_host} -p #{current_resource.ibmc_port} -U #{current_resource.ibmc_username} --error-code"
      end

      def call_urest(subcmd)
        # Copy urest file first
        copy_urest
        cmd = [build_cmd_str, "-P #{current_resource.ibmc_password}", subcmd].join(' ')
        # cmd_pass_masked = [build_cmd_str, '-P ***', subcmd].join(' ')

        # For customize command line output, use Mixlib::ShellOut instead of shell_out!
        urest_pipe = Mixlib::ShellOut.new(cmd, cwd: IbmcCookbook::Const::DIR_UREST_BIN, :timeout => 7200)
        urest_pipe.run_command

        if urest_pipe.error?
           # uREST console script writes output to stdout even failed.
          Chef::Log.error("\n[#{current_resource.ibmc_host}] " + urest_pipe.stderr.chomp('') + urest_pipe.stdout.chomp(''))
        else
          Chef::Log.info("\n[#{current_resource.ibmc_host}]\n" + urest_pipe.stdout.chomp(''))
        end

        # all ibmc custom action not up-to-date
        # https://stackoverflow.com/questions/40884166/how-to-make-a-chef-custom-resource-execute-on-every-chef-run
        new_resource.updated_by_last_action(true)
                

        # Chef::Application.fatal!(urest_pipe.stdout.chomp(''))
        # return if urest_pipe.error?
	      raise urest_pipe.stdout.chomp('') if urest_pipe.error?

        # raise exception if error
        # urest_pipe.error!
      end

      # Check required properties
      def check_required_properties(*props)
        props.each do |prop|
          unless new_resource.methods.include?(prop.to_sym)
            raise "No property name is '#{prop}'"
          end

          met = new_resource.method(prop.to_sym)
          unless property_is_set?(prop.to_sym) || !met.call.nil?
            raise Chef::Exceptions::ValidationFailed, "property '#{prop}' is required"
          end
        end
      end

      # Build optional argument string
      def build_optional_arg_str(map)
        # Iterate over map
        # if value is nil, skip
        # if value is blank String, skip
        # if value is not blank String, quote the value
        # if value type is boolean, transform value to python boolean type
        # if value type is Array, join elements with space
        # [key, value].join(' ')
        # push to array
        # join array with space
        arg_array = []
        map.each do |k, v|
          next if v.nil?
          next if (v.instance_of? String) && v.strip.empty?

          if v.instance_of? String
            v = %('#{v}')
          elsif [true, false].include? v
            v = v ? 'True' : 'False'
          elsif v.instance_of? Array
            v = v.join(' ')
          end
          arg_array.push([k, v].join(' '))
        end
        arg_array.join(' ')
      end
    end

    # Return an array which elements are class constant value
    def self.c_to_a(klass)
      klass.constants.map { |c| klass.const_get(c) }
    end

    private

    # Set properties from data
    def load_ibmc_properties(data)
      ibmc_host data['host'] unless property_is_set?(:ibmc_host)
      ibmc_port data['port'] unless property_is_set?(:ibmc_port)
      ibmc_username data['username'] unless property_is_set?(:ibmc_username)
      ibmc_password data['password'] unless property_is_set?(:ibmc_password)
    end

    # Check properties
    # raise exception when required property not set
    def ibmc_properties_is_set?(raise_error = false)
      is_host_set = property_is_set?(:ibmc_host)
      is_user_set = property_is_set?(:ibmc_username)
      is_pass_set = property_is_set?(:ibmc_password)

      unless is_host_set
        msg = 'ibmc_host must be set!'
        raise msg if raise_error
      end
      unless is_user_set
        msg = 'ibmc_username must be set!'
        raise msg if raise_error
      end
      unless is_pass_set
        msg = 'ibmc_password must be set!'
        raise msg if raise_error
      end

      is_host_set && is_user_set && is_pass_set
    end

    # Ignore exception
    def ignore_exception(default)
      yield
    rescue
      default
    end
  end
end