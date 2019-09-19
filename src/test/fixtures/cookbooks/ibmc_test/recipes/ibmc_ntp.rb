ibmc_ntp 'set' do
  ntp_addr_origin 'Static'
  service_enabled true
  pre_ntp_server '112.93.129.103'
  min_polling_interval 6
  max_polling_interval 10
  server_auth_enabled true
  action :set
end

ibmc_ntp 'get' do
  action :get
end
