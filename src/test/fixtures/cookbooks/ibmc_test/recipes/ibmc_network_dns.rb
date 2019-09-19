ibmc_ethernet_dns 'set dns' do
  address_origin 'Static'
  hostname 'server5'
  domain 'server5.huawei2.com'
  preferred_server '8.8.8.8'
  alternate_server '2009::2000'
  action :set
end
