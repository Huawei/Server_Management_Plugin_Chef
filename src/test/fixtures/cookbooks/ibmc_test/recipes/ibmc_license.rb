# In order to run this test case successfully, license must be installed on the BMC.

export_to = '/tmp/chef-ibmc-test-license.xml'
ibmc_license 'export' do
  export_to export_to
  notifies :delete, 'ibmc_license[delete]', :immediately
  action :export
end

ibmc_license 'delete' do
  action :nothing
end

ibmc_license 'install' do
  type 'URI'
  content export_to
  subscribes :install, 'ibmc_license[delete]', :immediately
  action :nothing
end
