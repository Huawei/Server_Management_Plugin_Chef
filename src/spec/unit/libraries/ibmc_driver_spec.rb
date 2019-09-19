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

describe 'ibmc_firmware_inband' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_firmware_inband
  context 'get' do
    context 'with parameters' do
      file = '/file/a.old'

      recipe do
        ibmc_firmware_inband 'test' do
          file file
          action :get
        end
      end

      it do
        arg = build_optional_arg_str(
          '-F': file
        )
        subcmd = IbmcCookbook::Const::Subcmd::GET_DRIVER.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_firmware_inband 'test' do
          action :get
        end
      end

      it do
        subcmd = IbmcCookbook::Const::Subcmd::GET_DRIVER.to_cmd('')
        is_expected.to run_execute(subcmd)
      end
    end
  end

  context 'upgrade' do
    context 'with parameters' do
      image_uri = 'image uri'
      signature_uri = 'signature uri'
      parameter = 'param'
      mode = 'Auto'
      active_method = 'OSRestart'

      recipe do
        ibmc_firmware_inband 'test' do
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
        subcmd = IbmcCookbook::Const::Subcmd::UPGRADE_DRIVER.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_firmware_inband 'test' do
          action :upgrade
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end
end
