#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_snmp
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
  class IbmcSnmp < BaseResource
    resource_name :ibmc_snmp

    property :v1_enabled, [true, false]
    property :v2_enabled, [true, false]
    property :long_pass_enabled, [true, false]
    property :rw_community_enabled, [true, false]
    property :readonly_community, String
    property :readwrite_community, String
    property :v3_auth_protocol, String, equal_to: %w(MD5 SHA1)
    property :v3_priv_protocol, String, equal_to: %w(DES AES)
    property :service_enabled, [true, false]
    property :trap_version, String, equal_to: %w(V1 V2C V3)
    property :trap_v3_user, String
    property :trap_mode, String, equal_to: %w(OID EventCode PreciseAlarm)
    property :trap_server_identity, String, equal_to: %w(BoardSN ProductAssetTag HostName)
    property :community_name, String
    property :alarm_severity, String, equal_to: %w(Critical Major Minor Normal)
    property :trap_server1_enabled, [true, false]
    property :trap_server2_enabled, [true, false]
    property :trap_server3_enabled, [true, false]
    property :trap_server4_enabled, [true, false]
    property :trap_server1_address, String
    property :trap_server2_address, String
    property :trap_server3_address, String
    property :trap_server4_address, String
    property :trap_server1_port, Integer
    property :trap_server2_port, Integer
    property :trap_server3_port, Integer
    property :trap_server4_port, Integer

    action :get do
      subcmd = Const::Subcmd::GET_SNMP.to_cmd
      call_urest(subcmd)
    end

    action :set do
      arg = build_optional_arg_str(
        '-V1': new_resource.v1_enabled,
        '-V2': new_resource.v2_enabled,
        '-LP': new_resource.long_pass_enabled,
        '-RWE': new_resource.rw_community_enabled,
        '-ROC': new_resource.readonly_community,
        '-RWC': new_resource.readwrite_community,
        '-V3AP': new_resource.v3_auth_protocol,
        '-V3EP': new_resource.v3_priv_protocol,
        '-TS': new_resource.service_enabled,
        '-TV': new_resource.trap_version,
        '-TU': new_resource.trap_v3_user,
        '-TM': new_resource.trap_mode,
        '-TSI': new_resource.trap_server_identity,
        '-TC': new_resource.community_name,
        '-TAS': new_resource.alarm_severity,
        '-TS1-Enabled': new_resource.trap_server1_enabled,
        '-TS2-Enabled': new_resource.trap_server2_enabled,
        '-TS3-Enabled': new_resource.trap_server3_enabled,
        '-TS4-Enabled': new_resource.trap_server3_enabled,
        '-TS1-Addr': new_resource.trap_server1_address,
        '-TS2-Addr': new_resource.trap_server2_address,
        '-TS3-Addr': new_resource.trap_server3_address,
        '-TS4-Addr': new_resource.trap_server4_address,
        '-TS1-Port': new_resource.trap_server1_port,
        '-TS2-Port': new_resource.trap_server2_port,
        '-TS3-Port': new_resource.trap_server3_port,
        '-TS4-Port': new_resource.trap_server4_port
      )
      if arg.empty?
        # TODO: check
        log 'No argument specified. Do nothing'
        return
      end
      subcmd = Const::Subcmd::SET_SNMP.to_cmd(arg)
      call_urest(subcmd)
    end
  end
end
