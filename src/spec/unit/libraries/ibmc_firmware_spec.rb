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

describe 'ibmc_firmware_outband' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_firmware_outband
  context 'get' do
    recipe do
      ibmc_firmware_outband 'test' do
        action :get
      end
    end

    it do
      subcmd = IbmcCookbook::Const::Subcmd::GET_BMC_FIRMWARE.to_cmd
      is_expected.to run_execute(subcmd)
    end
  end

  context 'upgrade' do
    context 'with parameters' do
      image_uri = 'image_uri'

      recipe do
        ibmc_firmware_outband 'test' do
          image_uri image_uri
          action :upgrade
        end
      end

      it do
        arg = build_optional_arg_str(
          '-i': image_uri
        )
        subcmd = IbmcCookbook::Const::Subcmd::UPGRADE_BMC_FIRMWARE.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_firmware_outband 'test' do
          action :upgrade
        end
      end

      it do
        subcmd = IbmcCookbook::Const::Subcmd::UPGRADE_BMC_FIRMWARE.to_cmd('')
        is_expected.to run_execute(subcmd)
      end
    end
  end
end
