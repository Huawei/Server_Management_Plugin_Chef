username = 'chef-ibmc-test'
new_username = 'new-username'

ibmc_user 'add' do
  username username
  password [*('a'..'z'), *('A'..'Z'), *('0'..'9')].sample(18).join
  role 'Commonuser'
  action :add
end

ibmc_user 'set' do
  username username
  new_username new_username
  notifies :get, "ibmc_user[get #{new_username}]", :immediately
  notifies :delete, "ibmc_user[delete #{new_username}]", :immediately
  action :set
end

ibmc_user "get #{username}" do
  username username
  action :nothing
end

ibmc_user "get #{new_username}" do
  username new_username
  action :nothing
end

ibmc_user "delete #{username}" do
  username username
  action :nothing
end

ibmc_user "delete #{new_username}" do
  username new_username
  action :nothing
end
