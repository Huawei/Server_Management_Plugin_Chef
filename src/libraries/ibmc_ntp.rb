#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_ntp
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
  class IbmcNtp < BaseResource
    resource_name :ibmc_ntp

    @@polling_interval_validator = {
      'should be between 3 and 17' => lambda do |v|
                                        v && (v.instance_of? Integer) && v.between?(3, 17)
                                      end,
    }

    property :ntp_addr_origin, String, equal_to: %w(IPv4 Static IPv6)
    property :service_enabled, [true, false]
    property :pre_ntp_server, String
    property :alt_ntp_server, String
    property :min_polling_interval, Integer, callbacks: @@polling_interval_validator
    property :max_polling_interval, Integer, callbacks: @@polling_interval_validator
    property :server_auth_enabled, [true, false]

    action :set do
      arg = build_optional_arg_str(
        '-M': new_resource.ntp_addr_origin,
        '-S': new_resource.service_enabled,
        '-PRE': new_resource.pre_ntp_server,
        '-ALT': new_resource.alt_ntp_server,
        '-MIN': new_resource.min_polling_interval,
        '-MAX': new_resource.max_polling_interval,
        '-AUT': new_resource.server_auth_enabled
      )

      subcmd = Const::Subcmd::SET_NTP.to_cmd(arg)
      call_urest(subcmd)
    end

    action :get do
      subcmd = Const::Subcmd::GET_NTP.to_cmd
      call_urest(subcmd)
    end
  end
end
