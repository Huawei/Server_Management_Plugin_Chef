#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_bios
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

module IbmcCookbook
  class IbmcBios < BaseResource
    resource_name :ibmc_bios

    property :attribute, String
    property :value, String

    action :get do
      check_required_properties(:attribute)
      args = [new_resource.attribute]
      subcmd = Const::Subcmd::GET_BIOS.to_cmd(*args)
      call_urest(subcmd)
    end

    action :set do
      check_required_properties(:attribute, :value)
      args = [new_resource.attribute, new_resource.value]
      subcmd = Const::Subcmd::SET_BIOS.to_cmd(*args)
      call_urest(subcmd)
    end

    action :restore do
      subcmd = Const::Subcmd::RESTORE_BIOS.to_cmd
      call_urest(subcmd)
    end
  end
end
