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
  $ensure      = undef,
  $hostname    = undef,
  $export      = undef,
  $conf_file   = undef,
  $template    = undef,
  $node_id     = undef,
  $db_server   = undef,
  $db_database = undef,
  $db_user     = undef,
  $db_password = undef) {
  include zabbix::params
  $ensure_real      = $ensure ? {
    undef   => $zabbix::params::server_enable,
    default => $ensure
  }
  $conf_file_real   = $conf_file ? {
    undef   => $zabbix::params::server_conf_file,
    default => $conf_file
  }
  $template_real    = $template ? {
    undef   => $zabbix::params::server_template,
    default => $template
  }
  $node_id_real     = $node_id ? {
    undef   => $zabbix::params::server_node_id,
    default => $node_id
  }
  $db_server_real   = $db_server ? {
    undef   => $zabbix::params::server_db_server,
    default => $db_server
  }
  $db_database_real = $db_database ? {
    undef   => $zabbix::params::server_db_database,
    default => $db_database
  }
  $db_user_real     = $db_user ? {
    undef   => $zabbix::params::server_db_user,
    default => $db_user
  }
  $db_password_real = $db_password ? {
    undef   => $zabbix::params::server_db_password,
    default => $db_password
  }
  $hostname_real    = $hostname ? {
    undef   => $zabbix::params::server_hostname,
    default => $hostname
  }
  $export_real      = $export ? {
    undef   => $zabbix::params::server_export,
    default => $export
  }

  require zabbix::agent

  case $::operatingsystem {
    'Gentoo' : {
      class { 'zabbix::server::gentoo':
        ensure => $ensure_real
      }
    }
    default  : {
      # fail silently for now
    }
  }

  package { 'activerecord':
    ensure => $ensure,
    before => File[$conf_file_real]
  }

  $service_ensure = $ensure_real ? {
    absent  => stopped,
    default => running
  }
  $service_enable = $ensure_real ? {
    absent  => false,
    default => true
  }

  file { $conf_file_real:
    ensure  => $ensure_real,
    content => template($template_real),
    notify  => Service['zabbix-server']
  }

  service { 'zabbix-server':
    ensure => $service_ensure,
    enable => $service_enable
  }

  if $export_real == present {
    # export myself to all agents
    @@zabbix::agent::server { $hostname_real:
      ensure   => present,
      hostname => $hostname_real
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
