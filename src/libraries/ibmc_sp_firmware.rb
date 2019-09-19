#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_sp_firmware
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
  class IbmcSpFirmware < BaseResource
    resource_name :ibmc_sp_firmware

    property :image_uri, String
    property :parameter, String
    property :mode, String, equal_to: %w(Auto Full Recover APP Driver)
    property :active_method, String

    action :get do
      subcmd = Const::Subcmd::GET_SP.to_cmd
      call_urest(subcmd)
    end

    action :upgrade do
      check_required_properties(:image_uri, :parameter, :mode, :active_method)

      Chef::Log.warn("Upgrade SP may take a long time, please be patient.")
      arg = build_optional_arg_str(
        '-i': new_resource.image_uri,
        '-si': "Null",
        '-PARM': new_resource.parameter,
        '-M': new_resource.mode,
        '-ACT': new_resource.active_method
      )
      subcmd = Const::Subcmd::UPGRADE_SP.to_cmd(arg)
      call_urest(subcmd)
    end

    # action :enable do
    #   arg = '-S True'
    #   # Set SP start enabled
    #   subcmd = Const::Subcmd::SET_SP_INFO.to_cmd(arg)
    #   call_urest(subcmd)

    #   # reset_type = 'ForceRestart'
    #   # # Restart OS
    #   # subcmd = Const::Subcmd::SYS_POWER_CTRL.to_cmd(reset_type)
    #   # call_urest(subcmd)
    # end
  end
end
