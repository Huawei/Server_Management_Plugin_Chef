#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_ethernet_ipv6
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
  class IbmcEthernetIpv6 < BaseResource
    resource_name :ibmc_ethernet_ipv6

    property :address, String
    property :origin, String, equal_to: %w(Static DHCPv6)
    property :gateway, String
    property :prefix_len, Integer

    action :set do
      arg = build_optional_arg_str(
        '-IP': new_resource.address,
        '-M': new_resource.origin,
        '-G': new_resource.gateway,
        '-L': new_resource.prefix_len
      )
      subcmd = Const::Subcmd::SET_IPV6.to_cmd(arg)
      call_urest(subcmd)
    end
  end
end
