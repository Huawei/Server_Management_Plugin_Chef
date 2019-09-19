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

describe 'ibmc_license' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_license
  context 'install' do
    context 'with parameters' do
      source = 'eSight'
      type = 'URI'
      content = 'https://localhost/adsfadsf'

      recipe do
        ibmc_license 'test' do
          source source
          type type
          content content
          action :install
        end
      end

      it do
        args = [source, type, content]
        subcmd = IbmcCookbook::Const::Subcmd::INSTALL_LICENSE.to_cmd(*args)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_license 'test' do
          action :install
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  context 'export' do
    export_to = 'https://localhost/asdfd'

    context 'with parameters' do
      recipe do
        ibmc_license 'test' do
          export_to export_to
          action :export
        end
      end

      it do
        subcmd = IbmcCookbook::Const::Subcmd::EXPORT_LICENSE.to_cmd(export_to)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_license 'test' do
          action :export
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  context 'delete' do
    recipe do
      ibmc_license 'test' do
        action :delete
      end
    end

    it do
      subcmd = IbmcCookbook::Const::Subcmd::DELETE_LICENSE.to_cmd
      is_expected.to run_execute(subcmd)
    end
  end
end
