#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_ethernet_dns
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
  class IbmcEthernetDns < BaseResource
    resource_name :ibmc_ethernet_dns

    property :address_origin, String, equal_to: %w(Static IPv4 IPv6)
    property :hostname, String
    property :domain, String
    property :preferred_server, String
    property :alternate_server, String

    action :set do
      arg = build_optional_arg_str(
        '-M': new_resource.address_origin,
        '-H': new_resource.hostname,
        '-D': new_resource.domain,
        '-PRE': new_resource.preferred_server,
        '-ALT': new_resource.alternate_server
      )
      subcmd = Const::Subcmd::SET_DNS.to_cmd(arg)
      call_urest(subcmd)
    end
  end
end
