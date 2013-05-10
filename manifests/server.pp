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
  $db_password = hiera('db_password', '')
) {
  
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
    default  : {
      # fail silently for now
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
  
  mysql::db { $db_database :
    user     => $db_user,
    password => $db_password,
    host     => $db_server,
    grant    => ['all'],
    enforce_sql => [
      '/usr/share/zabbix/database/mysql/schema.sql',
      '/usr/share/zabbix/database/mysql/images.sql'
    ]
  }

  service { 'zabbix-server':
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => Mysql::Db[$db_database]
  }

  File[$conf_file] ~> Service['zabbix-server']

  if $export == present {
    # export myself to all agents
    @@zabbix::agent::server { $hostname:
      ensure   => present,
      hostname => $hostname,
    }
    # install templates needed by different nodes
    Zabbix_template <<| |>>
    Zabbix_template_application <<| |>>
    Zabbix_template_item <<| |>>
    Zabbix_trigger <<| |>>
    Zabbix_hostgroup <<| |>>
    Zabbix_host <<| |>>
  }
}
