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

username = 'test-user'
password = 'test-pass'
describe 'ibmc_user' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_user
  context 'add' do
    context 'with parameters' do
      role = 'Commonuser'

      recipe do
        ibmc_user 'test' do
          username username
          password password
          role role
          action :add
        end
      end

      it do
        args = [username, password, role]
        subcmd = IbmcCookbook::Const::Subcmd::ADD_USER.to_cmd(*args)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_user 'test' do
          action :add
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  context 'delete' do
    context 'with parameters' do
      recipe do
        ibmc_user 'test' do
          username username
          action :delete
        end
      end

      it do
        subcmd = IbmcCookbook::Const::Subcmd::DEL_USER.to_cmd(username)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_user 'test' do
          action :delete
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  context 'set' do
    context 'with all parameters' do
      new_username = 'new-username'
      new_password = 'new-password'
      new_role = 'Commonuser'
      locked = false
      enabled = true

      recipe do
        ibmc_user 'test' do
          username username
          new_username new_username
          new_password new_password
          new_role new_role
          locked locked
          enabled enabled
          action :set
        end
      end

      it do
        arg = build_optional_arg_str(
          '-N': username,
          '-NN': new_username,
          '-NP': new_password,
          '-NR': new_role,
          '-Enabled': enabled
        )
        arg += ' -Locked' if locked
        subcmd = IbmcCookbook::Const::Subcmd::SET_USER.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'with one parameter' do
      recipe do
        ibmc_user 'test' do
          username username
          action :set
        end
      end

      it do
        arg = build_optional_arg_str(
          '-N': username
        )
        subcmd = IbmcCookbook::Const::Subcmd::SET_USER.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_user 'test' do
          action :set
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  context 'get' do
    context 'with parameters' do
      recipe do
        ibmc_user 'test' do
          username username
          action :get
        end
      end

      it do
        arg = build_optional_arg_str(
          '-N': username
        )
        subcmd = IbmcCookbook::Const::Subcmd::GET_USER.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_user 'test' do
          action :get
        end
      end

      it do
        subcmd = IbmcCookbook::Const::Subcmd::GET_USER.to_cmd('')
        is_expected.to run_execute(subcmd)
      end
    end
  end
end
