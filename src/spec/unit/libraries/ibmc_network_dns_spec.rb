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

describe 'ibmc_ethernet_dns' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_ethernet_dns
  context 'set' do
    context 'with parameters' do
      address_origin = 'Static'
      hostname = 'hostname'
      domain = 'domain'
      preferred_server = 'localhost'
      alternate_server = 'localhost'

      recipe do
        ibmc_ethernet_dns 'test' do
          address_origin address_origin
          hostname hostname
          domain domain
          preferred_server preferred_server
          alternate_server alternate_server
          action :set
        end
      end

      it do
        arg = build_optional_arg_str(
          '-M': address_origin,
          '-H': hostname,
          '-D': domain,
          '-PRE': preferred_server,
          '-ALT': alternate_server
        )
        subcmd = IbmcCookbook::Const::Subcmd::SET_DNS.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_ethernet_dns 'test' do
          action :set
        end
      end

      it do
        subcmd = IbmcCookbook::Const::Subcmd::SET_DNS.to_cmd('')
        is_expected.to run_execute(subcmd)
      end
    end
  end
end
