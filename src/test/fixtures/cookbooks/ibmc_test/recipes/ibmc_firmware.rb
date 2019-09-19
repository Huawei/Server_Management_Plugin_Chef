ibmc_firmware_outband 'get' do
  action :get
end

image_uri = node['ibmc']['firmware']['image_uri']
ibmc_firmware_outband 'upgrade' do
  image_uri image_uri
  action :upgrade
end
