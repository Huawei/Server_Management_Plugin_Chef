#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_boot
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

# Explicitly require lib, avoid lib load order issue
require_relative 'base_resource'
require_relative 'const'

module IbmcCookbook
  class IbmcBoot < BaseResource
    resource_name :ibmc_boot

    @boot_seq_option = %w(Cd Pxe Hdd Others)
    property :target, String, equal_to: %w(None Pxe Floppy Cd Hdd BiosSetup)
    property :enabled, String, equal_to: %w(Once Disabled Continuous)
    property :mode, String, equal_to: %w(Legacy UEFI)
    msg = "should be a string Array, which element should be one of #{@boot_seq_option}"
    property :seq, Array, callbacks: {
      msg => lambda do |s|
               return false unless s.instance_of? Array
               s.each do |e|
                 return false unless @boot_seq_option.include?(e)
               end
             end,
    }

    action :get do
      subcmd = Const::Subcmd::GET_SYS_BOOT.to_cmd
      call_urest(subcmd)
    end

    action :set_order do
      check_required_properties(:seq)
      arg = new_resource.seq.join(' ')
      subcmd = Const::Subcmd::SET_SYS_BOOT_ORDER.to_cmd(arg)
      call_urest(subcmd)
    end

    action :set_override do
      check_required_properties(:target, :enabled, :mode)
      args = [new_resource.target, new_resource.enabled, new_resource.mode]
      subcmd = Const::Subcmd::SET_SYS_BOOT_OVERRIDE.to_cmd(*args)
      call_urest(subcmd)
    end
  end
end
