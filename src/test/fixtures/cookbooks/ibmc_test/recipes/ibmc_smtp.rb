ibmc_smtp 'set' do
  email_subject 'Server Alert Chef Test'
  email_subject_contains %w(HostName BoardSN)
  action :set
end

ibmc_smtp 'get' do
  action :get
end

ibmc_smtp 'set' do
  email_subject 'Server Alert'
  email_subject_contains %w(HostName BoardSN ProductAssetTag)
  action :set
end
