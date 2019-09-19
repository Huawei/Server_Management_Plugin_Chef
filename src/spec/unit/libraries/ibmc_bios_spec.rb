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

attribute = 'bios-attribute'
value = 'bios-value'
describe 'ibmc_bios' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_bios
  context 'get' do
    context 'with parameters' do
      recipe do
        ibmc_bios 'test' do
          attribute attribute
          action :get
        end
      end

      it do
        subcmd = IbmcCookbook::Const::Subcmd::GET_BIOS.to_cmd(attribute)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_bios 'test' do
          action :get
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  context 'set' do
    context 'with parameters' do
      recipe do
        ibmc_bios 'test' do
          attribute attribute
          value value
          action :set
        end
      end

      it do
        subcmd = IbmcCookbook::Const::Subcmd::SET_BIOS.to_cmd(attribute, value)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_bios 'test' do
          action :set
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  context 'restore' do
    recipe do
      ibmc_bios 'test' do
        action :restore
      end
    end

    it do
      subcmd = IbmcCookbook::Const::Subcmd::RESTORE_BIOS.to_cmd
      is_expected.to run_execute(subcmd)
    end
  end
end
