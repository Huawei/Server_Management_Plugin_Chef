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

describe 'ibmc_os_deploy' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_os_deploy
  context 'install' do
    context 'with parameters' do
      file = 'file path'
      recipe do
        ibmc_os_deploy 'test' do
          file file
          action :install
        end
      end

      it do
        arg = build_optional_arg_str(
          '-T': 'SPOSInstallPara',
          '-F': file
        )
        subcmd = IbmcCookbook::Const::Subcmd::ADD_SP_CFG.to_cmd(arg)
        is_expected.to run_execute(subcmd)

        subcmd = IbmcCookbook::Const::Subcmd::SYS_POWER_CTRL.to_cmd('ForceRestart')
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_os_deploy 'test' do
          action :install
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end
end
