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

describe 'ibmc_indicator_led' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_indicator_led
  context 'set' do
    context 'with parameters' do
      state = 'Lit'

      recipe do
        ibmc_indicator_led 'test' do
          state state
          action :set
        end
      end

      it do
        subcmd = IbmcCookbook::Const::Subcmd::SET_INDICATOR_LED.to_cmd(state)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_indicator_led 'test' do
          action :set
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end
end
