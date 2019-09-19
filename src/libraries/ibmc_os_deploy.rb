#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_os_deploy
#
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

require_relative 'base_resource'
require_relative 'const'

module IbmcCookbook
  class IbmcOsDeploy < BaseResource
    resource_name :ibmc_os_deploy

    # property :service_type, String, equal_to: %w(SPNetDev SPRAID SPOSInstallPara)
    property :file, String

    action :install do
      check_required_properties(:file)

      # Add SP config
      arg = build_optional_arg_str(
        '-T': 'SPOSInstallPara',
        '-F': new_resource.file
      )
      subcmd = Const::Subcmd::ADD_SP_CFG.to_cmd(arg)
      call_urest(subcmd)

      reset_type = 'ForceRestart'
      # Restart OS
      subcmd = Const::Subcmd::SYS_POWER_CTRL.to_cmd(reset_type)
      call_urest(subcmd)
    end
  end
end
