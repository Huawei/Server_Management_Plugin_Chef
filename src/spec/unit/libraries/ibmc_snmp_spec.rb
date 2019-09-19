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

require 'spec_helper'

describe 'ibmc_snmp' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_snmp

  context 'get' do
    recipe do
      ibmc_snmp 'test' do
        action :get
      end
    end

    it do
      subcmd = IbmcCookbook::Const::Subcmd::GET_SNMP.to_cmd
      is_expected.to run_execute(subcmd)
    end
  end

  context 'set' do
    v1_enabled = true
    v2_enabled = true
    long_pass_enabled = true
    rw_community_enabled = true
    readonly_community = 'test'
    readwrite_community = 'test2'
    v3_auth_protocol = 'MD5'
    v3_priv_protocol = 'DES'
    service_enabled = true
    trap_version = 'V1'
    trap_v3_user = 'user'
    trap_mode = 'OID'
    trap_server_identity = 'BoardSN'
    community_name = 'aasdfa'
    alarm_severity = 'Minor'
    trap_server1_enabled = true
    trap_server2_enabled = true
    trap_server3_enabled = false
    trap_server4_enabled = false
    trap_server1_address = 's1.localhost'
    trap_server2_address = 's2.localhost'
    trap_server3_address = 's3.localhost'
    trap_server4_address = 's4.localhost'
    trap_server1_port = 11111
    trap_server2_port = 11112
    trap_server3_port = 11113
    trap_server4_port = 11114

    context 'with all parameters' do
      recipe do
        ibmc_snmp 'test' do
          v1_enabled v1_enabled
          v2_enabled v2_enabled
          long_pass_enabled long_pass_enabled
          rw_community_enabled rw_community_enabled
          readonly_community readonly_community
          readwrite_community readwrite_community
          v3_auth_protocol v3_auth_protocol
          v3_priv_protocol v3_priv_protocol
          service_enabled service_enabled
          trap_version trap_version
          trap_v3_user trap_v3_user
          trap_mode trap_mode
          trap_server_identity trap_server_identity
          community_name community_name
          alarm_severity alarm_severity
          trap_server1_enabled trap_server1_enabled
          trap_server2_enabled trap_server2_enabled
          trap_server3_enabled trap_server3_enabled
          trap_server4_enabled trap_server4_enabled
          trap_server1_address trap_server1_address
          trap_server2_address trap_server2_address
          trap_server3_address trap_server3_address
          trap_server4_address trap_server4_address
          trap_server1_port trap_server1_port
          trap_server2_port trap_server2_port
          trap_server3_port trap_server3_port
          trap_server4_port trap_server4_port
          action :set
        end

        it do
          arg = build_optional_arg_str(
            '-V1': v1_enabled,
            '-V2': v2_enabled,
            '-LP': long_pass_enabled,
            '-RWE': rw_community_enabled,
            '-ROC': readonly_community,
            '-RWC': readwrite_community,
            '-V3AP': v3_auth_protocol,
            '-V3EP': v3_priv_protocol,
            '-TS': service_enabled,
            '-TV': trap_version,
            '-TU': trap_v3_user,
            '-TM': trap_mode,
            '-TSI': trap_server_identity,
            '-TC': community_name,
            '-TAS': alarm_severity,
            '-TS1-Enabled': trap_server1_enabled,
            '-TS2-Enabled': trap_server2_enabled,
            '-TS3-Enabled': trap_server3_enabled,
            '-TS4-Enabled': trap_server3_enabled,
            '-TS1-Addr': trap_server1_address,
            '-TS2-Addr': trap_server2_address,
            '-TS3-Addr': trap_server3_address,
            '-TS4-Addr': trap_server4_address,
            '-TS1-Port': trap_server1_port,
            '-TS2-Port': trap_server2_port,
            '-TS3-Port': trap_server3_port,
            '-TS4-Port': trap_server4_port
          )
          subcmd = IbmcCookbook::Const::Subcmd::SET_SNMP.to_cmd(arg)
          is_expected.to run_execute(subcmd)
        end
      end
    end

    context 'with one parameter' do
      recipe do
        ibmc_snmp 'test' do
          v1_enabled v1_enabled
          action :set
        end
      end

      it do
        arg = build_optional_arg_str(
          '-V1': v1_enabled
        )
        subcmd = IbmcCookbook::Const::Subcmd::SET_SNMP.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_snmp 'test' do
          action :set
        end
      end

      it 'write log' do
        is_expected.to write_log('No argument specified. Do nothing')
      end
    end
  end
end
