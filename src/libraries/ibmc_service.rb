#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_service
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
  class IbmcService < BaseResource
    resource_name :ibmc_service

    property :protocol, String, equal_to: %w(HTTP HTTPS SNMP VirtualMedia IPMI SSH KVMIP SSDP VNC)
    property :state, [true, false]
    property :port, Integer
    property :notify_ttl, Integer
    property :notify_ipv6_scope, String, equal_to: %w(Link Site Organization)
    property :notify_multi_cast_interval, Integer

    action :get do
      arg = build_optional_arg_str(
        '-PRO': new_resource.protocol
      )
      subcmd = Const::Subcmd::GET_NET_SVC.to_cmd(arg)
      call_urest(subcmd)
    end

    action :set do
      check_required_properties(:protocol)
      arg = build_optional_arg_str(
        '-PRO': new_resource.protocol,
        '-S': new_resource.state,
        '-p': new_resource.port,
        '-NTTL': new_resource.notify_ttl,
        '-NIPS': new_resource.notify_ipv6_scope,
        '-NMIS': new_resource.notify_multi_cast_interval
      )
      subcmd = Const::Subcmd::SET_NET_SVC.to_cmd(arg)
      call_urest(subcmd)
    end
  end
end
