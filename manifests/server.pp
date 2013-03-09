# == Class: zabbix::server
#
# Set up a Zabbix server
#
# === Parameters
#
# [*ensure*]
#  present or abenst
# [*hostname*]
#  hostname of local machine
# [*export*]
#  present or absent, use storeconfigs to inform clients of server location
# [*conf_file*]
#  path to configuration file
# [*template*]
#  name of puppet template used
# [*node_id*]
# [*db_server*]
#  mysql server hostname
# [*db_database*]
#  mysql server schema name
# [*db_user*]
#  mysql server username
# [*db_password*]
#  mysql server password
#
class zabbix::server (
  $ensure      = hiera('server_enable', present),
  $hostname    = hiera('server_hostname', 'zabbix'),
  $export      = hiera('export', present),
  $conf_file   = hiera('server_conf_file', '/etc/zabbix/zabbix_server.conf'),
  $template    = hiera('server_template', 'zabbix/zabbix_server.conf.erb'),
  $node_id     = hiera('server_node_id', 0),
  $db_server   = hiera('db_server', 'localhost'),
  $db_database = hiera('db_database', 'zabbix'),
  $db_user     = hiera('db_user', 'root'),
  $db_password = hiera('db_password', '')) {
  
  include activerecord
  require zabbix::agent

  case $::operatingsystem {
    'Gentoo' : {
      class { 'zabbix::server::gentoo':
        ensure => $ensure
      }
    }
  }

  $service_ensure = $ensure ? {
    absent  => stopped,
    default => running,
  }
  $service_enable = $ensure ? {
    absent  => false,
    default => true,
  }

  file { $conf_file:
    ensure  => $ensure,
    content => template($template),
  }

  service { 'zabbix-server':
    ensure => $service_ensure,
    enable => $service_enable,
  }

  Class['activerecord'] -> File[$conf_file] ~> Service['zabbix-server']

  if $export == present {
    # export myself to all agents
    @@zabbix::agent::server { $hostname:
      ensure   => present,
      hostname => $hostname,
    }
  }
}
