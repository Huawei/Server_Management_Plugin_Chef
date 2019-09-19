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

describe 'ibmc_ntp' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_ntp
  context 'set' do
    ntp_addr_origin = 'IPv4'
    service_enabled = true
    pre_ntp_server = 'localhost'
    alt_ntp_server = 'localhost'
    min_polling_interval = 3
    max_polling_interval = 5
    server_auth_enabled = true
    context 'with all parameters' do
      recipe do
        ibmc_ntp 'test' do
          ntp_addr_origin ntp_addr_origin
          service_enabled service_enabled
          pre_ntp_server pre_ntp_server
          alt_ntp_server alt_ntp_server
          min_polling_interval min_polling_interval
          max_polling_interval max_polling_interval
          server_auth_enabled server_auth_enabled
          action :set
        end
      end

      it do
        # cmd = build_cmd_str
        arg = build_optional_arg_str(
          '-M': ntp_addr_origin,
          '-S': service_enabled,
          '-PRE': pre_ntp_server,
          '-ALT': alt_ntp_server,
          '-MIN': min_polling_interval,
          '-MAX': max_polling_interval,
          '-AUT': server_auth_enabled
        )
        subcmd = IbmcCookbook::Const::Subcmd::SET_NTP.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'with one parameter' do
      recipe do
        ibmc_ntp 'test' do
          ntp_addr_origin ntp_addr_origin
          action :set
        end
      end

      it do
        arg = build_optional_arg_str(
          '-M': ntp_addr_origin
        )
        subcmd = IbmcCookbook::Const::Subcmd::SET_NTP.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_ntp 'test' do
          action :set
        end
      end

      it do
        subcmd = IbmcCookbook::Const::Subcmd::SET_NTP.to_cmd('')
        is_expected.to run_execute(subcmd)
      end
    end
  end

  context 'get' do
    recipe do
      ibmc_ntp 'test' do
        action :get
      end
    end

    it do
      subcmd = IbmcCookbook::Const::Subcmd::GET_NTP.to_cmd
      is_expected.to run_execute(subcmd)
    end
  end
end
