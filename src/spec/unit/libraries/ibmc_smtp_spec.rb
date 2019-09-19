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

describe 'ibmc_smtp' do
  include_context 'ibmc data_bag context'
  platform 'ubuntu'
  step_into :ibmc_smtp
  context 'get' do
    recipe do
      ibmc_smtp 'test' do
        action :get
      end
    end

    it do
      subcmd = IbmcCookbook::Const::Subcmd::GET_SMTP.to_cmd
      is_expected.to run_execute(subcmd)
    end
  end

  context 'set' do
    service_enabled = true
    server_addr = 'localhost'
    tls_enabled = true
    anonymous_login_enabled = false
    sender_addr = 'localhost'
    sender_password = 'password'
    sender_username = 'username'
    email_subject = 'subject'
    email_subject_contains = %w(HostName ProductAssetTag BoardSN)
    alarm_severity = 'Major'

    context 'with all parameters' do
      recipe do
        ibmc_smtp 'test' do
          service_enabled service_enabled
          server_addr server_addr
          tls_enabled tls_enabled
          anonymous_login_enabled anonymous_login_enabled
          sender_addr sender_addr
          sender_password sender_password
          sender_username sender_username
          email_subject email_subject
          email_subject_contains email_subject_contains
          alarm_severity alarm_severity
          action :set
        end
      end

      it do
        arg = build_optional_arg_str(
          '-S': service_enabled,
          '-SERVER': server_addr,
          '-TLS': tls_enabled,
          '-ANON': anonymous_login_enabled,
          '-SA': sender_addr,
          '-SP': sender_password,
          '-SU': sender_username,
          '-ES': email_subject,
          '-ESC': email_subject_contains,
          '-AS': alarm_severity
        )
        subcmd = IbmcCookbook::Const::Subcmd::SET_SMTP.to_cmd(arg)
        is_expected.to run_execute(subcmd)
      end
    end

    context 'with one parameter' do
      recipe do
        ibmc_smtp 'test' do
          service_enabled service_enabled
          action :set
        end

        it do
          arg = build_optional_arg_str(
            '-S': service_enabled
          )
          subcmd = IbmcCookbook::Const::Subcmd::SET_SMTP.to_cmd(arg)
          is_expected.to run_execute(subcmd)
        end
      end
    end

    context 'with wrong parameter' do
      wrong_subject_kw = %w(abc cba)

      recipe do
        ibmc_smtp 'test' do
          email_subject_contains wrong_subject_kw
          action :set
        end
      end

      it 'raises ValidationFailed' do
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end

    context 'without parameters' do
      recipe do
        ibmc_smtp 'test' do
          action :set
        end
      end

      it do
        subcmd = IbmcCookbook::Const::Subcmd::SET_SMTP.to_cmd('')
        is_expected.to run_execute(subcmd)
      end
    end
  end
end
