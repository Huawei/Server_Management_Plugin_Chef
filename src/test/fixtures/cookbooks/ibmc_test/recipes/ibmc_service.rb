ibmc_service 'get' do
  protocol 'HTTP'
  action :get
end

ibmc_service 'set' do
  protocol 'HTTP'
  state true
  port 80
  action :set
end
