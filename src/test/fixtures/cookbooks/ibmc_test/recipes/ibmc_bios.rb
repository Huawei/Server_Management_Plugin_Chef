attribute = 'CustomPowerPolicy'
value = 'Custom'

ibmc_bios 'get' do
  attribute attribute
  action :get
end

ibmc_bios 'set' do
  attribute attribute
  value value
  action :set
end

ibmc_bios 'restore' do
  action :restore
end
