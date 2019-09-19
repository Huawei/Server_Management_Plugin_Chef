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

describe 'ibmc_boot' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_boot
  context 'get' do
    recipe do
      ibmc_boot 'test' do
        action :get
      end
    end

    it do
      subcmd = IbmcCookbook::Const::Subcmd::GET_SYS_BOOT.to_cmd
      is_expected.to run_execute(subcmd)
    end
  end

  context 'set_order' do
    context 'with parameters' do
      seq = %w(Cd Pxe Hdd Others)
      recipe do
        ibmc_boot 'test' do
          seq seq
          action :set_order
        end
      end

      it do
        arg = seq.join(' ')
        subcmd = IbmcCookbook::Const::Subcmd::SET_SYS_BOOT_ORDER.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'with wrong parameters' do
      context 'string' do
        recipe do
          ibmc_boot 'test' do
            seq 'asdf'
            action :set_order
          end
        end

        it 'raise ValidationFailed' do
          expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
        end
      end

      context 'random string array' do
        recipe do
          ibmc_boot 'test2' do
            seq %w(a b)
            action :set_order
          end
        end

        it 'raise ValidationFailed' do
          expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
        end
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_boot 'test' do
          action :set_order
        end
      end

      it 'raise ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  context 'set_override' do
    context 'with parameters' do
      target = 'Pxe'
      enabled = 'Once'
      mode = 'Legacy'
      recipe do
        ibmc_boot 'test' do
          target target
          enabled enabled
          mode mode
          action :set_override
        end
      end

      it do
        args = [target, enabled, mode]
        subcmd = IbmcCookbook::Const::Subcmd::SET_SYS_BOOT_OVERRIDE.to_cmd(*args)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_boot 'test' do
          action :set_override
        end
      end

      it 'raise ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end
end
