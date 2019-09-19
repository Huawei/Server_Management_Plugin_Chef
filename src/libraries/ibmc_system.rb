#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_system
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
  class IbmcSystem < BaseResource
    resource_name :ibmc_system

    property :asset_tag, String
    property :product_alias, String

    action :get do
      subcmd = Const::Subcmd::GET_PRODUCT_INFO.to_cmd
      call_urest(subcmd)
    end

    action :set do
      arg = build_optional_arg_str(
        '-Tag': new_resource.asset_tag,
        '-Al': new_resource.product_alias
      )
      subcmd = Const::Subcmd::SET_PRODUCT_INFO.to_cmd(arg)
      call_urest(subcmd)
    end
  end
end
