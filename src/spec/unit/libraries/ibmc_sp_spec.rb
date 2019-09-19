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

describe 'ibmc_sp_firmware' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_sp_firmware
  context 'get' do
    recipe do
      ibmc_sp_firmware 'test' do
        action :get
      end
    end

    it do
      subcmd = IbmcCookbook::Const::Subcmd::GET_SP.to_cmd
      is_expected.to run_execute(subcmd)
    end
  end

  context 'upgrade' do
    image_uri = 'image uri'
    signature_uri = 'uri'
    parameter = 'param'
    mode = 'Auto'
    active_method = 'active method'

    context 'with parameters' do
      recipe do
        ibmc_sp_firmware 'test' do
          image_uri image_uri
          signature_uri signature_uri
          parameter parameter
          mode mode
          active_method active_method
          action :upgrade
        end
      end

      it do
        arg = build_optional_arg_str(
          '-i': image_uri,
          '-si': signature_uri,
          '-PARM': parameter,
          '-M': mode,
          '-ACT': active_method
        )
        subcmd = IbmcCookbook::Const::Subcmd::UPGRADE_SP.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'with wrong mode' do
      recipe do
        ibmc_sp_firmware 'test' do
          image_uri image_uri
          signature_uri signature_uri
          parameter parameter
          mode 'wrong mode'
          active_method active_method
          action :upgrade
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_sp_firmware 'test' do
          action :upgrade
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  context 'enable' do
    recipe do
      ibmc_sp_firmware 'enable' do
        action :enable
      end
    end

    it do
      subcmd = IbmcCookbook::Const::Subcmd::SET_SP_INFO.to_cmd('-S True')
      is_expected.to run_execute(subcmd)

      subcmd = IbmcCookbook::Const::Subcmd::SYS_POWER_CTRL.to_cmd('ForceRestart')
      is_expected.to run_execute(subcmd)
    end
  end
end
