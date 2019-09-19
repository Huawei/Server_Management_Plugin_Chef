ibmc_indicator_led 'light up' do
  state 'Lit'
  action :set
end

ibmc_indicator_led 'blinking' do
  state 'Blinking'
  action :set
end

ibmc_indicator_led 'off' do
  state 'Off'
  action :set
end
