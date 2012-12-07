# == Node: default
#
# node for testing zabbix::externals
#
node default {
  class { 'zabbix::externals':
    ensure => 'present',
    api    => 'present'
  }
}
