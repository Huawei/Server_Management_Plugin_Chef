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

describe 'ibmc_service' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_service
  context 'get' do
    context 'with parameters' do
      protocol = 'HTTP'

      recipe do
        ibmc_service 'test' do
          protocol protocol
          action :get
        end
      end

      it do
        arg = build_optional_arg_str(
          '-PRO': protocol
        )
        subcmd = IbmcCookbook::Const::Subcmd::GET_NET_SVC.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'with wrong parameters' do
      recipe do
        ibmc_service 'test' do
          protocol 'asdfadf'
          action :get
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_service 'test' do
          action :get
        end
      end

      it do
        subcmd = IbmcCookbook::Const::Subcmd::GET_NET_SVC.to_cmd('')
        is_expected.to run_execute(subcmd)
      end
    end
  end

  context 'set' do
    protocol = 'HTTPS'
    state = true
    port = 33336
    notify_ttl = 60
    notify_ipv6_scope = 'Link'
    notify_multi_cast_interval = 60

    context 'with all parameters' do
      recipe do
        ibmc_service 'test' do
          protocol protocol
          state state
          port port
          notify_ttl notify_ttl
          notify_ipv6_scope notify_ipv6_scope
          notify_multi_cast_interval notify_multi_cast_interval
          action :set
        end
      end

      it do
        arg = build_optional_arg_str(
          '-PRO': protocol,
          '-S': state,
          '-p': port,
          '-NTTL': notify_ttl,
          '-NIPS': notify_ipv6_scope,
          '-NMIS': notify_multi_cast_interval
        )
        subcmd = IbmcCookbook::Const::Subcmd::SET_NET_SVC.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'with one parameter' do
      recipe do
        ibmc_service 'test' do
          protocol protocol
          action :set
        end
      end

      it do
        arg = build_optional_arg_str(
          '-PRO': protocol
        )
        subcmd = IbmcCookbook::Const::Subcmd::SET_NET_SVC.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_service 'test' do
          action :set
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end
end
