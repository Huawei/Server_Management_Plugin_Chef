ibmc_boot 'get' do
  action :get
end

ibmc_boot 'set_order' do
  seq %w(Cd Pxe Hdd Others)
  action :set_order
end

ibmc_boot 'set_override' do
  target 'None'
  enabled 'Disabled'
  mode 'Legacy'
  action :set_override
end
