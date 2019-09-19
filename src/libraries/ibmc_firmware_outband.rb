#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_firmware_outband
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
  class IbmcFirmwareOutband < BaseResource
    resource_name :ibmc_firmware_outband

    property :image_uri, String

    action :get do
      subcmd = Const::Subcmd::GET_BMC_FIRMWARE.to_cmd
      call_urest(subcmd)
    end

    action :upgrade do
      check_required_properties(:image_uri)
      Chef::Log.warn("Upgrade outband firmware may take a long time, please be patient.")
      arg = build_optional_arg_str(
        '-i': new_resource.image_uri
      )
      subcmd = Const::Subcmd::UPGRADE_BMC_FIRMWARE.to_cmd(arg)
      call_urest(subcmd)
    end
  end
end
