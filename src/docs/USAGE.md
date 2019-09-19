## Usage

This cookbook is not intended to include any recipes. Use it by specifiying a dependency on this cookbook in your own cookbook.

```ruby
# my_cookbook/metadata.rb
...
depends 'chef-ibmc-cookbook'
```
  
### Credentials

In order to use iBMC API, authentication credential needs to be present. There are 3 ways to handle this:

1. Using resource parameters(highest precedence)
2. Using attributes
3. Using data bag(lowest precedence)

#### Using resource parameters

All iBMC custom resources have iBMC credential properties:
- `ibmc_host`: String, iBMC host address
- `ibmc_port`: Integer, iBMC port
- `ibmc_username`: String, iBMC username
- `ibmc_password`: String, iBMC password

```ruby
ibmc_bios 'get bios' do
  ibmc_host 'ibmc-host'
  ibmc_port 443
  ibmc_username 'ibmc-user'
  ibmc_password 'ibmc-pass'
  attribute 'bios-attribute'
  action :get
end
```

#### Using attributes

Example Attributes:
```ruby
# /attributes/default.rb
default['ibmc']['main'] = {
  'host': 'ibmc-host',
  'port': 443,
  'username': 'ibmc-user',
  'password': 'ibmc-pass'
}
```

Then, you can use iBMC custom resource like this:
```ruby
ibmc_bios 'get bios' do
  attribute 'bios-attribute'
  action :get
end
```

#### Using data bag

Example Data Bag:
```json
% knife data bag show ibmc main
{
  "host": "ibmc-host",
  "port": 443,
  "username": "ibmc-user",
  "password": "ibmc-pass"
}
```

Then you can use iBMC custom resource like this:

```ruby
ibmc_bios 'get bios' do
  attribute 'bios-attribute'
  action :get
end
```

### Data encryption

There are many ways to encrypt data in chef. Here we only discuss one of them.

- `chef-vault` (need `Chef server` to work)
  
  `chef-vault` is a Ruby Gem that is included in Chef Workstation and the chef-client. `chef-vault` allows the encryption of a data bag item by using the public keys of a list of nodes, allowing only those nodes to decrypt the encrypted values. `chef-vault` uses the `knife vault` subcommand.

#### chef-vault

1. Use `knife vault` command to create vault
   ```bash
   # This will open an editor to fill out the json data
   # data example: {"hosts": [{"host": "ip", "port": port, "username": "username", "password": "password"}]}
   knife vault create ibmc credential -A "admin1,admin2"
   ```

2. Use vault in recipes
   
   In your cookbook, add `chef-vault` cookbook dependency:
   ```ruby
   # my_cookbook/metadata.rb
   ...
   depends 'chef-vault'
   ```

   Then, you can use it in recipe like:
   ```ruby
   include_recipe 'chef-vault'
   credential = ChefVault::Item.load('ibmc', 'credential')
   # Or use the helper library method:
   # credential = chef_vault_item('ibmc', 'credential')
   ```

   - For multiple host usage:
      
      Define vault data as:
      ```json  
      {
        "hosts": [
          {
            "host": "ip",
            "port": 443,
            "username": "username",
            "password": "password"
          },
          {
            ...
          }
        ]
      }
      ```
      Then in recipe:
      ```ruby
      hosts = credential['hosts']
      hosts.each do |h|
        ibmc_user "get" do
          ibmc_host h['host']
          ibmc_port h['port']
          ibmc_username h['username']
          ibmc_password h['password']
          username 'username'
          action :get
        end
      end

    - For single host usage:

      Define vault data as:
      ```json
        {
          "host": "ip",
          "port": 443,
          "username": "username",
          "password": "password"
        }
      ```
      
      Then in recipe:
      ```ruby
      host = credential
      ibmc_user "get" do
        ibmc_host host['host']
        ibmc_port host['port']
        ibmc_username host['username']
        ibmc_password host['password']
        username 'username'
        action :get
      end
      ```

### Logging

Configure log location and log level in `knife.rb`:
```ruby
log_level     :info
log_location  STDOUT
```

### Server mode

- Setup private `Chef Server` with `Chef Manage` according to [SERVER_INSTALL.md](SERVER_INSTALL.md) or use a [public one](https://manage.chef.io/)

- Download [Starter Kit](https://docs.chef.io/chefdk_setup.html#starter-kit) from `Chef Manage`; `Starter Kit` can be download in  `Administration` tab

- Extract `Starter Kit` to your work dir(assume `/tmp/`). Normally it will contain a `chef-repo` folder, with all server configuration sit inside `/tmp/chef-repo/.chef` dir

- Setup SSL certificates [link](https://docs.chef.io/chefdk_setup.html#get-ssl-certificates):
  ```bash
  knife ssl fetch
  ```

- If `chef-ibmc-cookbook` has been publish to `supermarket`, then just specify it as your cookbook dependency in `metadata.rb`.

- If `chef-ibmc-cookbook` has not been publish to `supermarket`, you can create `chef-ibmc-cookbook` archive according to [DISTRIBUTING.md](DISTRIBUTING.md), then extract it to your `chef-repo` root dir and specify it as your cookbook dependency in `metadata.rb`.

- Then upload your own cookbook and dependency to `Chef Server`:
  ```bash
  # Execute in chef-repo root dir
  # This command will upload all cookbooks in cookbooks dir
  knife upload cookbooks
  ```

- Then you can execute your cookbook like:
  ```bash
  sudo chef-client -c /tmp/chef-repo/.chef/knife.rb -o <your cookbook name>
  ```