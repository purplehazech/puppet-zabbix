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
  $ensure      = $zabbix::params::server_ensure,
  $hostname    = $zabbix::params::server_hostname,
  $export      = $zabbix::params::export,
  $conf_file   = $zabbix::params::server_conf_file,
  $template    = $zabbix::params::server_template,
  $node_id     = $zabbix::params::server_node_id,
  $db_server   = $zabbix::params::db_server,
  $db_database = $zabbix::params::db_database,
  $db_user     = $zabbix::params::db_user,
  $db_password = $zabbix::params::db_password) inherits zabbix::params {
  
  if ($ensure == present) {
    include activerecord
    require zabbix::agent
    
    Class['activerecord'] -> File[$conf_file]
  }

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

  File[$conf_file] ~> Service['zabbix-server']

  if $export == present {
    # export myself to all agents
    @@zabbix::agent::server { $hostname:
      ensure   => present,
      hostname => $hostname,
    }
  }
}
