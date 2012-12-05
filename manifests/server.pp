# == Class: zabbix::server
#
# set up a zabbix server
#
# @todo implement zabbix::server
class zabbix::server (
  $ensure      = undef,
  $conf_file   = undef,
  $template    = undef,
  $node_id     = undef,
  $db_server   = undef,
  $db_database = undef,
  $db_user     = undef,
  $db_password = undef,
  $hostname    = undef,
  $export      = undef) {
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
    content => template($template_real)
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
    Zabbix::Server::Template <<| |>>
  }
}
