# node.default['ibmc_os_deploy']['config'] = {
#   'InstallMode': 'Recommended',
#   'OSType': 'CentOS7U5',
#   'BootType': 'UEFIBoot',
#   'RootPwd': '***',
#   'HostName': 'chef-test',
#   'AutoPosition': true,
#   'Autopart': true,
#   'Language': 'en-US.UTF-8',
#   'TimeZone': 'Asia/Shanghai',
#   'Keyboard': 'us',
#   'CheckFirmware': false,
#   'Software': [
#     {
#       'FileName': 'iBMA',
#     },
#   ],
#   'NetCfg': [
#     {
#       'Device': {
#         'Name': 'eth0',
#         'MAC': '00:23:5A:15:99:42',
#       },
#       'IPv4Addresses': [
#         {
#           'Address': '10.10.10.10',
#           'SubnetMask': '255.255.0.0',
#           'Gateway': '10.10.10.1',
#           'AddressOrigin': 'Static',
#         },
#       ],
#     },
#   ],
#   'Packages': [
#     {
#       'PackageName': ['gcc'],
#       'PatternName': ['base'],
#     },
#   ],
# }

config_file_path = '/tmp/os.json'

file 'create os configuration file' do
  path config_file_path
  content Chef::JSONCompat.to_json_pretty(node['ibmc']['os']['config'])
  mode '0755'
end

ibmc_os_deploy 'install' do
  file config_file_path
  action :install
end
