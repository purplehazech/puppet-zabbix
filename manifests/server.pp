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
  $package     = $zabbix::params::server_package,
  $db_type     = $zabbix::params::db_type,
  $db_server   = $zabbix::params::db_server,
  $db_database = $zabbix::params::db_database,
  $db_user     = $zabbix::params::db_user,
  $db_password = $zabbix::params::db_password) inherits zabbix::params {

  $install_package    = $::operatingsystem ? {
    windows => false,
    default => true,
  }

  $lc_db_type = downcase($db_type)
  $server_base_dir = "/usr/share/zabbix-server-${lc_db_type}"

  if $package == '' {
    $real_package = "zabbix-server-${lc_db_type}"
  } else {
    $real_package = $package
  }

  if ($ensure == present) {
    include activerecord

    Class['activerecord'] -> File[$conf_file]
  }

  case $::operatingsystem {
    'Gentoo' : {
      class { 'zabbix::server::gentoo':
        ensure => $ensure
      }
    }
    'Debian','Ubuntu' : {
      include zabbix::debian
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

  mysql::grant { $db_database :
    mysql_user               => $db_user,
    mysql_password           => $db_password,
    mysql_host               => $db_server,
    mysql_db_init_query_file => '/usr/share/zabbix/database/mysql/schema.sql',
  }
  # @todo make mysql::grant understand arrays of sql files for the next lines
  # '/usr/share/zabbix/database/mysql/images.sql'
  # '/usr/share/zabbix/database/mysql/data.sql'

  service { 'zabbix-server':
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => Mysql::Grant[$db_database]
  }

  File[$conf_file] ~> Service['zabbix-server']

  if $install_package != false {
    package { $real_package:
      ensure => $ensure,
    }
    Package[$real_package] -> File[$conf_file]
  }

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
