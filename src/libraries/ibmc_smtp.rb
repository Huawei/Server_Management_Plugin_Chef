#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_smtp
#
# Copyright:: 2019, The Authors
#
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

require_relative 'base_resource'
require_relative 'const'

module IbmcCookbook

  class IbmcSmtp < BaseResource
    resource_name :ibmc_smtp

    property :service_enabled, [true, false]
    property :server_addr, String
    property :tls_enabled, [true, false]
    property :anonymous_login_enabled, [true, false]
    property :sender_addr, String
    property :sender_password, String, sensitive: true
    property :sender_username, String
    property :email_subject, String

    @email_subject_kws = %w(HostName BoardSN ProductAssetTag)
    msg = "should be a string Array, which element should be one of #{@email_subject_kws}"
    property :email_subject_contains, Array,
              callbacks: {
                msg => lambda do |s|
                         return false unless s.instance_of? Array
                         s.each do |e|
                           return false unless @email_subject_kws.include?(e.to_s)
                         end
                       end,
              }

    property :alarm_severity, String, equal_to: %w(Critical Major Minor Normal)

    action :get do
      subcmd = Const::Subcmd::GET_SMTP.to_cmd
      call_urest(subcmd)
    end

    action :set do
      arg = build_optional_arg_str(
        '-S': new_resource.service_enabled,
        '-SERVER': new_resource.server_addr,
        '-TLS': new_resource.tls_enabled,
        '-ANON': new_resource.anonymous_login_enabled,
        '-SA': new_resource.sender_addr,
        '-SP': new_resource.sender_password,
        '-SU': new_resource.sender_username,
        '-ES': new_resource.email_subject,
        '-ESC': new_resource.email_subject_contains,
        '-AS': new_resource.alarm_severity
      )

      subcmd = Const::Subcmd::SET_SMTP.to_cmd(arg)
      call_urest(subcmd)
    end
  end

  class IbmcSmtpRecipient < BaseResource
    resource_name :ibmc_smtp_recipient
    property :index, Integer
    property :enabled, [true, false]
    property :address, String
    property :desc, String

    action :set do
      check_required_properties(:index)

      unless new_resource.index.between?(1,4)
        raise Chef::Exceptions::ValidationFailed, "property index must be an integer between 1 and 4."
      end
      
      arg = build_optional_arg_str(
        "-R#{new_resource.index}-Addr": new_resource.address,
        "-R#{new_resource.index}-Desc": new_resource.desc,
        "-R#{new_resource.index}-Enabled": new_resource.enabled,
      )

      subcmd = Const::Subcmd::SET_SMTP.to_cmd(arg)
      call_urest(subcmd)
    end
  end
end
