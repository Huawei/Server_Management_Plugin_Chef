#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_sys_power
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
  class IbmcSysPower < BaseResource
    resource_name :ibmc_sys_power

    property :reset_type, String, equal_to: %w(On ForceOff GracefulShutdown ForceRestart Nmi ForcePowerCycle)

    action :set do
      check_required_properties(:reset_type)
      arg = new_resource.reset_type
      subcmd = Const::Subcmd::SYS_POWER_CTRL.to_cmd(arg)
      call_urest(subcmd)
    end
  end
end
