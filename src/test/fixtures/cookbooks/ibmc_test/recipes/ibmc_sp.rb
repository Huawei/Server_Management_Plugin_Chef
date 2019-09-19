ibmc_sp_firmware 'enable' do
  action :enable
end

image_uri = node['ibmc']['sp']['image_uri']
signature_uri = node['ibmc']['sp']['sign_uri']

ibmc_sp_firmware 'upgrade sp' do
  image_uri image_uri
  parameter 'all'
  active_method 'Restart'
  mode 'Auto'
  action :upgrade
end

ibmc_sp_firmware 'get' do
  action :get
end
