ibmc_system 'set' do
  asset_tag 'chef test'
  action :set
end

ibmc_system 'get' do
  action :get
end
