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
  $db_password = $zabbix::params::db_password) {

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

  mysql::db { $db_database :
    user        => $db_user,
    password    => $db_password,
    host        => $db_server,
    grant       => ['all'],
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

  if $install_package != false {
    package { $real_package:
      ensure => $ensure,
      notify => Exec['zabbix-server-schema']
    }
    Package[$real_package] -> File[$conf_file]
  }

  if $db_type == 'MYSQL' {
    $mysql_creds="--user=${db_user} --password=${db_password}"
    $mysql_params="${mysql_creds} --host=${db_server}"
    $mysql_command="mysql ${mysql_params} ${db_database}"

    exec { 'zabbix-server-schema':
      command     => "${mysql_command} < ${server_base_dir}/schema.sql",
      refreshonly => true,
      notify      => Exec['zabbix-server-images'],
    }
    exec { 'zabbix-server-images':
      command     => "${mysql_command} < ${server_base_dir}/images.sql",
      refreshonly => true,
      notify      => Exec['zabbix-server-data'],
    }
    exec { 'zabbix-server-data':
      command     => "${mysql_command} < ${server_base_dir}/data.sql",
      refreshonly => true,
    }
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
