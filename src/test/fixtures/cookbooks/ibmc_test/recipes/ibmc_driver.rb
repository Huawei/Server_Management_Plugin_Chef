image_uri = node['ibmc']['driver']['image_uri']
signature_uri = node['ibmc']['driver']['sign_uri']

ibmc_firmware_inband 'get' do
  action :get
end

ibmc_firmware_inband 'upgrade nic' do
  image_uri image_uri
  signature_uri signature_uri
  parameter 'all'
  active_method 'Restart'
  mode 'Auto'
  action :upgrade
end
