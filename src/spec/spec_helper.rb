# frozen_string_literal: true
require 'chefspec'
require 'chefspec/berkshelf'

# unshift 'libraries' directory to 'LOAD_PATH'
# for convenince require lib from 'libraries' directory
$LOAD_PATH.unshift('./libraries')

require 'const'

RSpec.shared_context 'ibmc data_bag context', shared_context: :metadata do
  attr_accessor :ibmc_host
  attr_accessor :ibmc_port
  attr_accessor :ibmc_username
  attr_accessor :ibmc_password

  before do
    @ibmc_host = 'localhost'
    @ibmc_port = 443
    @ibmc_username = 'ibmc-user'
    @ibmc_password = 'ibmc-pass'
    stub_data_bag('ibmc').and_return(%w(main is_dev))
    stub_data_bag_item('ibmc', 'main').and_return(host: ibmc_host, port: ibmc_port, username: ibmc_username, password: ibmc_password)
    stub_data_bag_item('ibmc', 'is_dev').and_return(true)
  end

  def build_cmd_str
    # call 'echo' instead of actual program while unit testing
    "echo -H #{@ibmc_host} -p #{@ibmc_port} -U #{@ibmc_username} -P #{@ibmc_password}"
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
        v = %("#{v}")
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

RSpec.configure do |rspec|
  # rspec.log_level = :debug
  rspec.include_context 'ibmc data_bag context', include_shared: true
end
