# == Class: zabbix::server
#
# set up a zabbix server
#
# @todo implement zabbix::server
class zabbix::server ($ensure = undef) {
  $ensure_real = $ensure ? {
    undef   => $zabbix::params::server,
    default => $ensure
  }

  case $::operatingsystem {
    'Gentoo' : {
      class { 'zabbix::server::gentoo':
        ensure => $ensure_real
      }
    }
  }

  case $ensure {
    present : {
      include zabbix::server::gentoo
      # install templates needed by different nodes
      Zabbix::Server::Template <<| |>>
    }
    absent  : {
    }
  }
}
