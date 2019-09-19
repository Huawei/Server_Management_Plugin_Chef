# chef-ibmc-cookbook Cookbook

This cookbook provides resources for configuring Huawei iBMC via their APIs. Included resources:

- BIOS Management(`ibmc_bios`)
- Inband Firmware Management(`ibmc_firmware_inband`)
- Outband Firmware Management(`ibmc_firmware_outband`)
- System Health Management
  - CPU Health(`ibmc_health_cpu`)
  - Drive Health(`ibmc_health_drive`)
  - Fan Health(`ibmc_health_fan`)
  - Memory Health(`ibmc_health_memory`)
  - Power Supply Health(`ibmc_health_psu`)
  - RAID Health(`ibmc_health_raid`)
  - Network Adapter Health(`ibmc_health_network_adapter`)
- Indicator State of Chassis Management(`ibmc_indicator_led`)
- License Management(`ibmc_license`)
- DNS Management(`ibmc_ethernet_dns`)
- IPv4 Network Management(`ibmc_ethernet_ipv4`)
- IPv6 Network Management(`ibmc_ethernet_ipv6`)
- IP Version Management(`ibmc_ethernet_ipversion`)
- VLAN Management(`ibmc_ethernet_vlan`)
- Manager Ethernet Interface Management(`ibmc_ethernet`)
- NTP Service Management(`ibmc_ntp`)
- Boot Management(`ibmc_boot`)
- CPU Management(`ibmc_cpu`)
- Physical Disk Management(`ibmc_drive`)
- OS Ethernet Information Management(`ibmc_os_eth`)
- Memory Management(`ibmc_memory`)
- OS Power Management(`ibmc_sys_power`)
- Product Information Management(`ibmc_system`)
- RAID Information Management(`ibmc_raid`)
- Network Adapter Management(`ibmc_network_adapter`)
- OS Management(`ibmc_os_deploy`)
- BMC Power Management(`ibmc_restart`)
- Network Service Management(`ibmc_service`)
- SMTP Service Management(`ibmc_smtp`)
- SMTP Recipient Management(`ibmc_smtp_recipient`)
- SNMP Service Management(`ibmc_snmp`)
- SP Service Management(`ibmc_sp`)
- SP Firmware Management(`ibmc_sp_firmware`)
- User Management(`ibmc_user`)
- Virtual Media Management(`ibmc_vmm`)

## Requirements

### Platforms

- Ubuntu 14.04+
- CentOS 7.3+

### ENV

- python 2.7

### Chef

- Chef 13.0+

### Cookbooks

- none

### How to use the iBMC Cookbook:

This cookbook is not intended to include any recipes. Use it by specifiying a dependency on this cookbook in your own cookbook.

```ruby
# my_cookbook/metadata.rb
...
depends 'chef-ibmc-cookbook'
```
  
## Credentials

In order to use iBMC API, authentication credential needs to be present. 
Remember to add `sensitive` attribute to chef resource to avoid chef displaying credential when resource failed.

All iBMC custom resources have iBMC credential properties:
- `ibmc_host`: String, iBMC host address (IPv4, IPv6, domain) 
- `ibmc_port`: Integer, iBMC port
- `ibmc_username`: String, iBMC username
- `ibmc_password`: String, iBMC password

```ruby
ibmc_bios 'get bios' do
  sensitive true
  ibmc_host 'ibmc-host'
  ibmc_port 443
  ibmc_username 'ibmc-user'
  ibmc_password 'ibmc-pass'
  attribute 'bios-attribute'
  action :get
end
```


## Resources

  All resource has no default action, so action must be set explicitly.

### ibmc_bios

Manage BIOS

#### Actions:

- `get`: Get BIOS information.
  
  - Properties:

    - `attribute`: String. **Required**.
  
      BIOS attribute. 

- `set`: Set BIOS attributes.
  
  - Properties:

    - `attribute`: String. **Required**.
      
      BIOS attribute. 

    - `value`: String. **Required**.
      
      BIOS attribute value. 

- `restore`: Restore BIOS default settings.

#### Examples:

```ruby
ibmc_bios 'get' do
  attribute 'attribute-name'
  action :get
end
```

### ibmc_firmware_inband

Get inband firmware infomation. Only V5 servers used with BIOS version later than 0.39 support this function.

#### Actions:

- `get`: Get inband firmwares.

  - Properties:

    None

- `upgrade`: Upgrade inband firmware.

    Those transfered firmwares takes effect upon next system restart when SP Service start is enabled. Only V5 servers used with BIOS version later than 0.39 support this function.
  
  - Properties:

    - `image_uri`: String. **Required**.

      File URI of firmware update image file. The firmware upgrade file should be .zip format.
      It supports HTTPS, SFTP, NFS, CIFS, SCP file transfer protocols.
      The URI cannot contain the following special characters: ||, ;, &&, $, |, >>, >, <.

      For examples:
      - remote path: protocol://username:password@hostname/directory/Firmware.zip

    - `signature_uri`: String. **Required**.

      File path of the certificate file of the upgrade file.
      - Signal file should be in .asc format.
      - it supports HTTPS, SFTP, NFS, CIFS, SCP file transfer protocols.
      - The URI cannot contain the following special characters: ||, ;, &&, $, |, >>, >, <

      For examples:
      - remote path: protocol://username:password@hostname/directory/Firmware.zip.asc

    - `parameter`: String. **Required**.
      
      Only supports `all` for now. `all` indicates the entire upgrade package or a specific upgrade package (for example package1.rpm).

    - `mode`: String. **Required**.

      Mode of the upgrade. Value could be `Auto`, `Full`, `Recover`, `APP` or `Driver`.

    - `active_method`: String. **Required**.

      How does the upgrade take effect. Only supports `OSRestart` for now.

#### Examples:

```ruby
ibmc_firmware_inband 'get' do
  action :get
end

ibmc_firmware_inband 'upgrade' do
  image_uri 'image URI'
  signature_uri 'signature URI'
  parameter 'all'
  mode 'Auto'
  active_method 'OSRestart'
  action :upgrade
end
```

### ibmc_firmware_outband

Manage outband firmware. if upgrade CPLD and BIOS, it takes effect on next OS power off.

#### Actions:

- `get`: Get outband firmware infomation.
  
  - Properties:

    None

- `upgrade`: Upgrade outband firmware.

  - Properties:

    - `image_uri`: String.

      File URI of firmware update image file. File URI should be a string of up to 256 characters.
      It supports HTTPS, SCP, SFTP, CIFS, NFS transfer protocols and local file.

      For examples:
        - local path: /home/ubuntu/2288H_V5_5288_V5-iBMC-V318.hpm
        - remote path: protocol://username:password@hostname/directory/2288H_V5_5288_V5-iBMC-V318.hpm


#### Examples:

```ruby
ibmc_firmware_outband 'get' do
  action :get
end

ibmc_firmware_outband 'upgrade' do
  image_uri 'image_uri'
  action :upgrade
end
```

### ibmc_health_cpu

Manage CPU health

#### Actions:

- `get`: Get CPU health.

  - Properties:

    None

#### Examples:

```ruby
ibmc_health_cpu 'get' do
  action :get
end
```

### ibmc_health_drive

Manage drive health

#### Actions:

- `get`: Get drive health.

#### Examples:

```ruby
ibmc_health_drive 'get' do
  action :get
end
```

### ibmc_health_fan

Manage fan health

#### Actions:

- `get`: Get fan health.

  - Properties:

    None

#### Examples:

```ruby
ibmc_health_fan 'get' do
  action :get
end
```

### ibmc_health_memory

Manage memory health

#### Actions:

- `get`: Get memory health.

  - Properties:

    None

#### Examples:

```ruby
ibmc_health_memory 'get' do
  action :get
end
```

### ibmc_health_psu

Manage power supply health

#### Actions:

- `get`: Get power supply health.

  - Properties:

    None

#### Examples:

```ruby
ibmc_health_psu 'get' do
  action :get
end
```

### ibmc_health_raid

Manage RAID health

#### Actions:

- `get`: Get RAID health.

  - Properties:

    None

#### Examples:

```ruby
ibmc_health_raid 'get' do
  action :get
end
```

### ibmc_health_network_adapter

Manage network adapter health

#### Actions:

- `get`: Get network adapter health.

  - Properties:

    None

#### Examples:

```ruby
ibmc_health_network_adapter 'get' do
  action :get
end
```

### ibmc_indicator_led

Manage indicator state of chassis

#### Actions:

- `set`: Set indicator state of chassis.

  - Properties:

    - `state`: String. **Required**. 
      
      Indicator state of chassis. Value could be `Lit`, `Off` or `Blinking`.

#### Examples:

```ruby
ibmc_indicator_led 'light up' do
  state 'Lit'
  action :set
end
```

### ibmc_license

Manage iBMC license

#### Actions:

- `get`: Get license information.

  - Properties:

    None

- `install`: Install license.

  V3 servers and some V5 servers do not support this function. For details, see the iBMC User Guide.

  - Properties:

    - `source`: String. Default `iBMC`. **Required**.

      License source. Value could be `iBMC`, `FusionDirector` or `eSight`.

    - `type`: String. **Required**.

      Content type. Only `URI` is support for now.

    - `content`: String. **Required**.

      XML format license file URI. It supports HTTPS, SFTP, NFS, SCP, CIFS transfer protocols and local file.

      For examples:
        - local path: /home/ubuntu/license.xml
        - remote path: protocol://username:password@hostname/directory/license.xml

- `export`: Export license.

  - Properties:

    - `export_to`: String. **Required**.

      The license file URI to be export to.
      Export to file path could be local path URI, 
      or remote path URI (protocols HTTPS, SFTP, NFS, CIFS, and SCP are supported).

      For examples:
        - local path: /home/ubuntu/license.xml
        - remote path: protocol://username:password@hostname/directory/license.xml

- `delete`: Delete license.

  - Properties:

    None

#### Examples:

```ruby
ibmc_license 'get' do
  action :get
end

ibmc_license 'install' do
  type 'URI'
  content 'License URI'
  action :install
end

ibmc_license 'export' do
  export_to 'export to URI'
  action :export
end

ibmc_license 'delete' do
  action :delete
end
```

### ibmc_ethernet_dns

Manage DNS

#### Actions:

- `set`: Set DNS information.

  - Properties:

    - `address_origin`: String.

      How DNS server information is obtained. Value coule be `Static`, `IPv4` or `IPv6`.

    - `hostname`: String.

      iBMC hostname.

    - `domain`: String.

      Server domain.

    - `preferred_server`: String.

      IP address of the preferred DNS server.

    - `alternate_server`: String.

      IP address of the alternate DNS server.

#### Examples:

```ruby
ibmc_ethernet_dns 'set' do
  address_origin 'Static'
  action :set
end
```

### ibmc_ethernet_ipv4

Manage IPv4 Network

#### Actions:

- `set`: Set IPv4 network.

  - Properties:

    - `address`: String.

      IPv4 address of the iBMC network port.

    - `origin`: String.

      How the IPv4 address is allocated. Value could be `Static` or `DHCP`.

    - `gateway`: String.

      Gateway IPv4 address of the iBMC network port.

    - `mask`: String.

      Subnet mask of the iBMC network port.

#### Examples:

```ruby
ibmc_ethernet_ipv4 'set' do
  address '10.10.10.2'
  origin 'Static'
  gateway '10.10.10.1'
  mask '255.255.255.0'
  action :set
end
```

### ibmc_ethernet_ipv6

Manage IPv6 Network

#### Actions:

- `set`: Set IPv6 network.

  - Properties:

    - `address`: String.

      IPv6 address of the iBMC network port.

    - `origin`: String.

      How the IPv6 address is allocated. Value could be `Static` or `DHCPv6`.

    - `gateway`: String.

      Gateway IPv6 address of the iBMC network port.

    - `prefix_len`: Integer.

      IPv6 address prefix length of the iBMC network port.

#### Examples:

```ruby
ibmc_ethernet_ipv6 'set' do
  origin 'Static'
  action :set
end
```

### ibmc_ethernet_ipversion

Manage IP version

#### Actions:

- `set`: Set IP version.

  - Properties:

    - `version`: String. **Required**.

      Enabled version of IP protocol. Value could be `IPv4AndIPv6`, `IPv4` or `IPv6`.

#### Examples:

```ruby
ibmc_ethernet_ipversion 'set' do
  version 'IPv4AndIPv6'
  action :set
end
```

### ibmc_ethernet_vlan

Manage VLAN network

#### Actions:

- `set`: Set VLAN network.

  - Properties:

    - `enabled`: `true` or `false`.

      Whether VLAN is enabled.

    - `id`: Integer.

      VLAN identifier. If VLAN is disabled(set `enabled` to false), id should not be set.

#### Examples:

```ruby
ibmc_ethernet_vlan 'set' do
  enabled true
  id 1111
  action :set
end
```

### ibmc_ethernet

Manage BMC ethernet interface

#### Actions:

- `get`: Get BMC ethernet interface information.

  - Properties:

    None

#### Examples:

```ruby
ibmc_ethernet 'get' do
  action :get
end
```

### ibmc_ntp

Manage NTP service

#### Actions:

- `get`: Get NTP service.

  - Properties:

    None

- `set`: Set NTP service.

  - Properties:

    - `ntp_addr_origin`: String.

      NTP mode. Value could be `Static`, `IPv4` or `IPv6`.

    - `service_enabled`: `true` or `false`.

      Whether NTP service is enabled.

    - `pre_ntp_server`: String.

      Preferred NTP server address.

    - `alt_ntp_server`: String.

      Alternative NTP server address.

    - `min_polling_interval`: Integer.

      Minimum NTP synchronization interval. Value ranges from 3 to 17.

    - `max_polling_interval`: Integer.

      Maximum NTP synchronization interval. Value ranges from 3 to 17.

    - `server_auth_enabled`: `true` or `false`.

      Whether authentication enabled.

#### Examples:

```ruby
ibmc_ntp 'get' do
  action :get
end

ibmc_ntp 'set' do
  ntp_addr_origin 'Static'
  service_enabled true
  pre_ntp_server '10.1.1.3'
  min_polling_interval 6
  max_polling_interval 10
  server_auth_enabled true
  action :set
end
```

### ibmc_boot

Manage OS boot setting

#### Actions:

- `get`: Get OS boot setting.

  - Properties:

    None

- `set_order`: Set OS boot order.

  - Properties:

    - `seq`: Array. **Required**.

      System boot order. Value should be an array of all boot device. Boot device could be `Cd`, `Pxe`, `Hdd` or `Others`.

- `set_override`: Set OS boot source override.

  - Properties:

    - `target`: String. **Required**.

      Boot source override target. Value could be `None`, `Pxe`, `Floppy`, `Cd`, `Hdd` or `BiosSetup`.

    - `enabled`: String. **Required**.

      Boot source override enabled. Value could be `Once`, `Disabled` or `Continuous`.

    - `mode`: String. **Required**.

      Boot source override mode. Value could be `Legacy` or `UEFI`.

#### Examples:

```ruby
ibmc_boot 'get boot info' do
  action :get
end

ibmc_boot 'set boot order' do
  seq ['Cd', 'Pxe', 'Hdd', 'Others']
  action :set_order
end
```

### ibmc_cpu

Manage OS cpu

#### Actions:

- `get`: Get OS cpu information.

  - Properties:

    None

#### Examples:

```ruby
ibmc_cpu 'get' do
  action :get
end
```

### ibmc_drive

Manage physical disk

#### Actions:

- `get`: Get the physical disk information.

  - Properties:

    None

#### Examples:

```ruby
ibmc_drive 'get' do
  action :get
end
```

### ibmc_os_eth

Manage OS ethernet interface

#### Actions:

- `get`: Get OS ethernet interface information.

  - Properties:

    None

#### Examples:

```ruby
ibmc_os_eth 'get' do
  action :get
end
```

### ibmc_memory

Manage OS memory

#### Actions:

- `get`: Get OS memory information.

  - Properties:

    None

#### Examples:

```ruby
ibmc_memory 'get' do
  action :get
end
```

### ibmc_sys_power

Manage OS power

#### Actions:

- `set`: Set OS power.

  - Properties:

    - `reset_type`: String. **Required**.

      System power reset type. Value could be `On`, `ForceOff`, `GracefulShutdown`, `ForceRestart`, `Nmi` or `ForcePowerCycle`.

#### Examples:

```ruby
ibmc_sys_power 'set' do
  reset_type 'On'
  action :set
end
```

### ibmc_system

Manage product information

#### Actions:

- `get`: Get product information.

  - Properties:

    None

- `set`: Set product information.

  - Properties:

    - `asset_tag`: String.

      Asset tag.

    - `product_alias`: String.

      Product alias.

#### Examples:

```ruby
ibmc_system 'get' do
  action :get
end

ibmc_system 'set' do
  asset_tag 'chef test'
  action :set
end
```

### ibmc_raid

Manage RAID information

#### Actions:

- `get`: Get RAID information

  - Properties:

    None

#### Examples:

```ruby
ibmc_raid 'get' do
  action :get
end
```

### ibmc_network_adapter

Manage network adapter information

#### Actions:

- `get`: Get network adapter information

  - Properties:

    None

#### Examples:

```ruby
ibmc_network_adapter 'get' do
  action :get
end
```


### ibmc_os_deploy

Manage OS deployment. Only V5 serial servers support this function.
Tips: This function is controlled by iBMC license. It can only be used if the iBMC import the license.

#### Actions:

- `install`: Install OS

  - Properties:

    - `file`: String. **Required**.

      Path to SP deployment configuration file. File path must be a local system file path.

#### Examples:

```ruby
ibmc_os_deploy 'install' do
  file 'config file path'
  action :install
end
```

### ibmc_restart

Manage BMC power

#### Actions:

- `restart`: Restart BMC.

  - Properties:

    None

#### Examples:

```ruby
ibmc_restart 'restart' do
  action :restart
end
```

### ibmc_service

Manage network service

#### Actions:

- `get`: Get network service information.

  - Properties:

    - `protocol`: String.

      Service protocol. Value could be `HTTP`, `HTTPS`, `SNMP`, `VirtualMedia`, `IPMI`, `SSH`, `KVMIP`, `SSDP` or `VNC`.

- `set`: Set netowrk service information.

  - Properties:

    - `protocol`: String. **Required**.

      Service protocol. Value could be `HTTP`, `HTTPS`, `SNMP`, `VirtualMedia`, `IPMI`, `SSH`, `KVMIP`, `SSDP` or `VNC`.

    - `state`: `true` or `false`.

      Whether service enabled.

    - `port`: Integer.

      Service port.

    - `notify_ttl`: Integer.
      
      Time for which the SSDP messages are valid. Value range from 1 to 255

    - `notify_ipv6_scope`: String.

      IPv6 multicast range of SSDP messages. Value could be `Link`, `Site` or `Organization`.

    - `notify_multi_cast_interval`: Integer.

      SSDP message multicast interval(in seconds).

#### Examples:

```ruby
ibmc_service 'get all service' do
  action :get
end

ibmc_service 'set HTTP service' do
  protocol 'HTTP'
  state true
  port 80
  action :set
end
```

### ibmc_smtp

Manage SMTP service

#### Actions:

- `get`: Get SMTP service information.

  - Properties:

    None

- `set`: Set SMTP service information.

  - Properties:

    - `service_enabled`: `true` or `false`.

      Whether SMTP service enabled.

    - `server_addr`: String.

      SMTP server address.

    - `tls_enabled`: `true` or `false`.

      Whether SMTP TLS enabled.

    - `anonymous_login_enabled`: `true` or `false`.

      Whether anonymous login enabled.

    - `sender_addr`: String.

      Email sender address.

    - `sender_password`: String.

      Email sender password.

    - `sender_username`: String.

      Email sender username.

    - `email_subject`: String.

      Email subject.

    - `email_subject_contains`: Array.

      Email subject keywords. Should be an array of keyword. Keyword could be `HostName`, `BoardSN` or `ProductAssetTag`.

    - `alarm_severity`: String.

      Severity level of alarm to be sent. Value could be `Critical`, `Major`, `Minor` or `Normal`.

#### Examples:

```ruby
ibmc_smtp 'get' do
  action :get
end
```

### ibmc_smtp_recipient

Manage SMTP Recipient

#### Actions:


- `set`: Set SMTP Recipient.

  - Properties:

    - `index`: 

      SMTP recipient index, value range: 1 to 4. At most 4 recipient is support.

    - `address`: String.

      Address of the recipient receiving alarm email notifications.

    - `desc`: String.

      Description of recipient

    - `enabled`: `true` or `false`.

      Whether this SMTP recipient allowed to receiving alarm email notifications.


#### Examples:

```ruby
ibmc_smtp_recipient 'set' do
  index 1
  address 'email address'
  desc 'recipient description'
  enabled true
  action :set
end
```

### ibmc_snmp

Manage SNMP service

#### Actions:

- `get`: Get SNMP service information.

  - Properties:

    None

- `set`: Set SNMP service information.

  - Properties:

    - `v1_enabled`: `true` or `false`.

      Whether SNMPv1 enabled.

    - `v2_enabled`: `true` or `false`.

      Whether SNMPv2 enabled.

    - `long_pass_enabled`: `true` or `false`.

      Whether long password enabled.

    - `rw_community_enabled`: `true` or `false`.

      Whether read-write community name enabled.

    - `readonly_community`: String.

      Read-only community name.

    - `readwrite_community`: String.

      Read-write community name.

    - `v3_auth_protocol`: String.

      SNMPv3 authentication algorithm. Value could be `MD5` or `SHA1`

    - `v3_priv_protocol`: String.

      SNMPv3 encryption algorithm. Value could be `DES` or `AES`.

    - `service_enabled`: `true` or `false`.
      
      Whether trap is enabled.

    - `trap_version`: String.

      Trap version. Value could be `V1`, `V2C` or `V3`.

    - `trap_v3_user`: String.

      SNMPv3 user name.

    - `trap_mode`: String.

      Trap mode. Value could be `OID`, `EventCode` or `PreciseAlarm`.

    - `trap_server_identity`: String.

      Host identifier. Value could be `BoardSN`, `ProductAssetTag` or `HostName`.

    - `community_name`: String.

      Community name.

    - `alarm_severity`, String.

      Severity level of the alarm to be sent. Value could be `Critical`, `Major`, `Minor` or `Normal`.

    - `trap_server1_enabled`: `true` or `false`.

      Whether trap server 1 enabled.

    - `trap_server2_enabled`: `true` or `false`.

      Whether trap server 2 enabled.

    - `trap_server3_enabled`: `true` or `false`.

      Whether trap server 3 enabled.

    - `trap_server4_enabled`: `true` or `false`.

      Whether trap server 4 enabled.

    - `trap_server1_address`: String.

      Trap server 1 address.

    - `trap_server2_address`: String.

      Trap server 2 address.

    - `trap_server3_address`: String.

      Trap server 3 address.

    - `trap_server4_address`: String.

      Trap server 4 address.

    - `trap_server1_port`: Integer.

      Trap server 1 port.

    - `trap_server2_port`: Integer.

      Trap server 2 port.

    - `trap_server3_port`: Integer.

      Trap server 3 port.

    - `trap_server4_port`: Integer.

      Trap server 4 port.

#### Examples:

```ruby
ibmc_snmp 'get' do
  action :get
end
```

### ibmc_sp

Manage SP service. Only V5 servers used with BIOS version later than 0.39 support this function.

#### Actions:

- `set`: set SP service.

  - Properties:

    - `start_enabled`: Boolean.

    Whether SP start is enabled.

    - `sys_restart_delay_seconds`: Integer.

    Maximum time allowed for the restart of the OS.

    - `timeout`: Integer.

    Maximum time allowed for SP deployment, value range is 300 to 86400.

    - `finished`: Boolean.

    Status of the transaction deployed.


- `result`: Get SP result.

  - Properties:

    None


#### Examples:

```ruby
ibmc_sp 'set' do
  start_enabled true
  sys_restart_delay_seconds 3600
  timeout 10800
  finished true
  action :set
end


ibmc_sp 'get sp result' do
  action :result
end
```

### ibmc_sp_firmware

Manage SP firmware. Only V5 servers used with BIOS version later than 0.39 support this function.

#### Actions:

- `get`: Get SP service information.

  - Properties:

    None

- `upgrade`: Upgrade SP service.
  
  - Properties:

    - `image_uri`: String. **Required**.

      File URI of firmware update image file. The firmware upgrade file is in .ISO format. 
      support only the CIFS and NFS protocols. The URI cannot contain the following special characters: ||, ;, &&, $, |, >>, >, <.

      For examples:
      - remote path: nfs://username:password@hostname/directory/Firmware.ISO

    - `parameter`: String. **Required**.

      `all` indicates the entire upgrade package or a specific upgrade package.

    - `mode`: String. **Required**.

      Mode of the upgrade. Value could be `Auto`, `Full`, `Recover`, `APP` or `Driver`.

    - `active_method`: String. **Required**.

      Only supports `OSRestart` for now.

#### Examples:

```ruby
ibmc_sp_firmware 'get' do
  action :get
end

ibmc_sp_firmware `upgrade` do
  image_uri 'image_uri'
  parameter 'all'
  active_method 'OSRestart'
  mode 'Auto'
  action :upgrade
end
```

### ibmc_user

Manage BMC user

#### Actions:

- `get`: Get BMC user.

  - Properties:

    None

- `add`: Add BMC user.

  - Properties:

    - `username`: String. **Required**.

      BMC user name.

    - `password`: String. **Required**.

      BMC user password. A string of up to 20 characters. If password complexity check is enabled for other interfaces, the password must meet password complexity requirements. If password complexity check is not enabled for other interfaces, there is not restriction on the password.

    - `role`: String. **Required**.

      BMC user role. Value could be `Administrator`, `Operator`, `Commonuser`, `NoAccess`, `CustomRole1`, `CustomRole2`, `CustomRole3` or `CustomRole4`.

- `delete`: Delete BMC user.

  - Properties:

    - `username`: String. **Required**.

      BMC user name.

- `set`: Set BMC user.

  - Properties:

    - `username`: String. **Required**.

      BMC user name.

    - `new_username`: String.

      BMC new user name.

    - `new_password`: String.

      BMC new user password.

    - `new_role`: String.

      BMC new user role. Value could be `Administrator`, `Operator`, `Commonuser`, `NoAccess`, `CustomRole1`, `CustomRole2`, `CustomRole3` or `CustomRole4`.

    - `locked`: `true` or `false`. Default `false`.

      Whether the user is locked.

    - `enabled`: `true` or `false`

      Whether the user enabled.

#### Examples:

```ruby
ibmc_user 'add user' do
  username 'test'
  password 'pass'
  role 'Commonuser'
  action :add
end

ibmc_user 'update user' do
  username 'test'
  new_username 'new_name'
  action :set
end

ibmc_user 'delete user' do
  username 'new_name'
  action :delete
end
```

### ibmc_vmm

Manage virtual media

#### Actions:

- `connect`: Connect virtual media.

  - Properties:

    - `image`: String. **Required**.

      URI of the virtual media image.  
      Only the URI connections using the Network File System (NFS), Common Internet File System (CIFS) or HTTPS protocols are supported.

- `disconnect`: Disconnect virtual media.

#### Examples:

```ruby
ibmc_vmm 'connect' do
  image 'image URI'
  action :connect
end

ibmc_vmm 'disconnect' do
  action :disconnect
end
```