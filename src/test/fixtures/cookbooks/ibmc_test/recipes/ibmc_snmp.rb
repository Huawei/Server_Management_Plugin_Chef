ibmc_snmp 'set' do
  v2_enabled false
  action :set
end

ibmc_snmp 'get' do
  action :get
end

ibmc_snmp 'set' do
  v2_enabled true
  action :set
end
