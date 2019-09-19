ibmc_ethernet_ipv4 'set ipv4' do
  address '112.93.129.9'
  origin 'Static'
  gateway '112.93.129.1'
  mask '255.255.255.0'
  action :set
end
