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

describe 'ibmc_ethernet_ipv6' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_ethernet_ipv6
  context 'set' do
    context 'with parameters' do
      address = '::1'
      origin = 'DHCPv6'
      gateway = '0:0:0:0:0:ffff:c0a8:101'
      prefix_len = 10

      recipe do
        ibmc_ethernet_ipv6 'test' do
          address address
          origin origin
          gateway gateway
          prefix_len prefix_len
          action :set
        end
      end

      it do
        arg = build_optional_arg_str(
          '-IP': address,
          '-M': origin,
          '-G': gateway,
          '-L': prefix_len
        )
        subcmd = IbmcCookbook::Const::Subcmd::SET_IPV6.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_ethernet_ipv6 'test' do
          action :set
        end
      end

      it do
        subcmd = IbmcCookbook::Const::Subcmd::SET_IPV6.to_cmd('')
        is_expected.to run_execute(subcmd)
      end
    end
  end
end
