#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_drive
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
  class IbmcDrive < BaseResource
    resource_name :ibmc_drive

    property :id, Integer,
              description: 'Physical disk id'

    # property :page, String, equal_to: %w(Enabled Disabled)

    action :get do
      arg = build_optional_arg_str(
        '-I': new_resource.id,
        # '-PA': new_resource.page
      )
      subcmd = Const::Subcmd::GET_DRIVE_INFO.to_cmd(arg)
      call_urest(subcmd)
    end
  end
end
