ibmc_vmm 'connect' do
  image node['ibmc']['vm']['image']
  action :connect
end

ibmc_vmm 'disconnect' do
  action :disconnect
end
