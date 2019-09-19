#
# Cookbook:: chef-ibmc-cookbook
# Resource:: ibmc_license
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
  class IbmcLicense < BaseResource
    resource_name :ibmc_license

    property :source, String,
              default: 'iBMC',
              equal_to: %w(iBMC FusionDirector eSight),
              description: 'License source, iBMC by default.'

    property :type, String,
              equal_to: %w(URI Text),
              description: 'Content type.
              Text: indicates the value is the license content.
              URI: indicates the value is URI (local path or remote path).'

    property :content, String,
              description: "Content of license.
              License text content if type is 'Text' while license file uri if type is 'URI'.
              License file URI supports both bmc local path URI (only under the /tmp directory),
              and remote path URI (protocols HTTPS, SFTP, NFS, CIFS, and SCP are supported)."

    property :export_to, String,
              description: 'The license file URI to be export to.
              Export to file path could be the BMC local path URI (under /tmp directory),
              or remote path URI (protocols HTTPS, SFTP, NFS, CIFS, and SCP are supported).'

    action :get do
      subcmd = Const::Subcmd::GET_LICENSE.to_cmd()
      call_urest(subcmd)
    end

    action :install do
      check_required_properties(:source, :type, :content)

      args = [new_resource.source, new_resource.type, new_resource.content]
      subcmd = Const::Subcmd::INSTALL_LICENSE.to_cmd(*args)
      call_urest(subcmd)
    end

    action :export do
      check_required_properties(:export_to)

      arg = new_resource.export_to
      subcmd = Const::Subcmd::EXPORT_LICENSE.to_cmd(arg)
      call_urest(subcmd)
    end

    action :delete do
      subcmd = Const::Subcmd::DELETE_LICENSE.to_cmd
      call_urest(subcmd)
    end
  end
end
