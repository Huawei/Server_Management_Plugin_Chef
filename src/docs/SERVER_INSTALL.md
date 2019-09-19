# This document describe how to install and configure *Chef server*

*Note: there are three configuration scenarios for the Chef server, we will only talk about `Standalone` scenario.*

All infomation in this doc can be found in [https://docs.chef.io/install_server.html](https://docs.chef.io/install_server.html)


## Requirements

- 4G RAM minimum.
- Others requirements can be found in [https://docs.chef.io/install_server_pre.html](https://docs.chef.io/install_server_pre.html)


## Download 

Download the package from [https://downloads.chef.io/chef-server/](https://downloads.chef.io/chef-server/)


## Install

The rest of these steps assume you downloaded the package to `/tmp/` directory.

- For Red Hat Enterprise Linux and CentOS:
  ```bash
  sudo rpm -Uvh /tmp/chef-server-core-<version>.rpm
  ```

- For Ubuntu:
  ```bash
  sudo dpkg -i /tmp/chef-server-core-<version>.deb
  ```

## Configure

#### Configure Chef server

```bash
sudo chef-server-ctl reconfigure
```

#### Create Chef server administrator

```bash
sudo chef-server-ctl user-create USER_NAME FIRST_NAME LAST_NAME EMAIL 'PASSWORD' --filename FILE_NAME
```
An RSA private key is generated automatically. This is the user’s private key and should be saved to a safe location. The `--filename` option will save the RSA private key to the specified absolute path.

For example:
```bash
sudo chef-server-ctl user-create janedoe Jane Doe janed@example.com 'abc123' --filename /path/to/janedoe.pem
```

#### Create an orgnization

```bash
sudo chef-server-ctl org-create short_name 'full_organization_name' --association_user user_name --filename ORGANIZATION-validator.pem
```
The name must begin with a lower-case letter or digit, may only contain lower-case letters, digits, hyphens, and underscores, and must be between 1 and 255 characters. For example: `4thcoffee`.

The full name must begin with a non-white space character and must be between 1 and 1023 characters. For example: `'Fourth Coffee, Inc.'`.

The `--association_user` option will associate the `user_name` with the `admins` security group on the Chef server.

An RSA private key is generated automatically. This is the chef-validator key and should be saved to a safe location. The `--filename` option will save the RSA private key to the specified absolute path.

For example:
```bash
sudo chef-server-ctl org-create 4thcoffee 'Fourth Coffee, Inc.' --association_user janedoe --filename /path/to/4thcoffee-validator.pem
```

#### WEB UI (Chef Manage)

On the Chef server, run:
```bash
sudo chef-server-ctl install chef-manage
```

then:
```bash
sudo chef-server-ctl reconfigure
```

and then:
```bash
sudo chef-manage-ctl reconfigure
# this step will prompt you a license to accept
```

## Finish

If you install and configure `Chef server` successfully, you can follow [this link](https://docs.chef.io/chefdk_setup.html) to setup a [chef repo](https://docs.chef.io/chef_repo.html)