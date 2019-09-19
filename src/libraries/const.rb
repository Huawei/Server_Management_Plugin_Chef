# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module IbmcCookbook
  module Const
    DIR_UREST = '/opt/chef_uREST'.freeze
    DIR_UREST_BIN = "#{DIR_UREST}/bin".freeze
    PATH_UREST_TAR = "#{DIR_UREST}/uREST.tar.gz".freeze

    class Subcmd
      private_class_method :new

      def initialize(fmt)
        @fmt = fmt
      end

      def to_cmd(*args)
        (@fmt % args).strip
      end

      ### constant ###
      ADD_USER = new(%(adduser -N "%s" -P "%s" -R "%s"))
      DEL_USER = new(%(deluser -N "%s"))
      SET_USER = new('setuser %s')
      GET_USER = new('getuser %s')

      GET_BIOS = new(%(getbios -A "%s"))
      SET_BIOS = new(%(setbios -A "%s" -V "%s"))
      RESTORE_BIOS = new('restorebios')
      GET_SYS_BOOT = new('getsysboot')
      SET_SYS_BOOT_ORDER = new(%(setsysboot -Q %s))
      SET_SYS_BOOT_OVERRIDE = new(%(setsysboot -T "%s" -TS "%s" -M "%s"))
      GET_SYS_ETH = new('getsyseth')
      GET_CPU = new('getcpu')
      GET_MEMORY = new('getmemory')
      GET_DRIVE_INFO = new('getpdisk %s')
      GET_RAID = new('getraid %s')
      GET_NETWORK_ADAPTER = new('getnetworkadapter')

      SYS_POWER_CTRL = new(%(syspowerctrl -T "%s"))
      BMC_POWER_CTRL = new('bmcpowerctrl')

      SET_NTP = new('setntp %s')
      GET_NTP = new('getntp')

      GET_SMTP = new('getsmtp')
      SET_SMTP = new('setsmtp %s')

      GET_SNMP = new('getsnmp')
      SET_SNMP = new('setsnmp %s')

      GET_NET_SVC = new('getnetsvc %s')
      SET_NET_SVC = new('setnetsvc %s')

      OPERATE_VM = new('connectvmm %s')

      INSTALL_LICENSE = new(%(installlicense -S "%s" -T "%s" -C "%s"))
      EXPORT_LICENSE = new(%(exportlicense -T "%s"))
      DELETE_LICENSE = new('deletelicense')
      GET_LICENSE = new('getlicenseinfo')

      GET_ETHERNET = new('getethernet')
      SET_DNS = new('setdns %s')
      SET_IPV4 = new('setipv4 %s')
      SET_IPV6 = new('setipv6 %s')
      SET_IPVERSION = new(%(setipversion -M "%s"))
      SET_VLAN = new('setvlan %s')

      SET_INDICATOR_LED = new(%(setindicatorled -S "%s"))

      GET_PRODUCT_INFO = new('getproductinfo')
      SET_PRODUCT_INFO = new('setproductinfo %s')

      GET_BMC_FIRMWARE = new('getfw')
      UPGRADE_BMC_FIRMWARE = new('upgradefw %s')

      GET_SP = new('getspinfo')
      GET_SP_RESULT = new('getspresult')
      UPGRADE_SP = new('upgradesp -T "SP" %s')
      SET_SP_INFO = new('setspinfo %s')
      ADD_SP_CFG = new('addspcfg %s')

      GET_DRIVER = new('getsphw %s')
      UPGRADE_DRIVER = new('upgradesp -T "Firmware" %s')

      GET_CPU_HEALTH = new('getcpuhealth')
      GET_RAID_HEALTH = new('getraidhealth')
      GET_MEMORY_HEALTH = new('getmemoryhealth')
      GET_PSU_HEALTH = new('getpsuhealth')
      GET_DRIVE_HEALTH = new('getpdiskhealth')
      GET_FAN_HEALTH = new('getfanhealth')
      GET_NETWORK_ADAPTER_HEALTH = new('getnetworkadapterhealth')
    end
  end unless defined?(Const) # See https://github.com/chef-cookbooks/firewall/pull/57
end
