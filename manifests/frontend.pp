# == Class: zabbix::frontend
#
# Install and manage zabbix frontend
#
# === Example Usage:
#
#   class { 'zabbix::frontend':
#     ensure       => present,
#     server_host  => 'zabbix-server.local',
#     server_name  => 'gentoo-dev',
#     hostname     => $fqdn,
#   }
#
# === Parmeters
# * *ensure*
#   absent or present
# * *server_host*
#   the zabbix server this belongs to
# * *server_host*
#   defaults to server
# * *hostname*
#   what hostname webapp shall use
# * *vhost_class*
#   class to use as the main vhost class, use to
#   replace zabbix::frontend::vhost if needed
# * *version*
#   zabbix version or skip to leave out most of this module
# * *base*
#   base path for web request_uri
#
class zabbix::frontend (
  $ensure      = undef,
  $server_host = undef,
  $server_name = undef,
  $hostname    = undef,
  $base        = undef,
  $vhost_class = undef,
  $version     = undef,
  $db_type     = undef,
  $db_server   = undef,
  $db_port     = undef,
  $db_database = undef,
  $db_user     = undef,
  $db_password = undef) {
  include zabbix::params
  $ensure_real = $ensure ? {
    undef   => $zabbix::params::frontend_ensure,
    default => $ensure
  }
  validate_re($ensure_real, [absent, present])
  $server_host_real = $server_host ? {
    undef   => $zabbix::params::server_host,
    default => $server_host
  }
  validate_string($server_host_real)
  $server_name_real = $server_name ? {
    undef   => $server_host_real,
    default => $server_name
  }
  validate_string($server_name)
  $hostname_real = $hostname ? {
    undef   => $zabbix::params::frontend_hostname,
    default => $hostname
  }
  validate_string($hostname_real)
  $base_real    = $base ? {
    undef   => $zabbix::params::frontend_base,
    default => $base
  }
  $version_real = $version ? {
    undef   => $zabbix::params::frontend_version,
    default => $version
  }
  validate_re($ensure_real, ['^[0-9].[0-9].[0-9]', present, absent, 'skip'])
  $vhost_class_real = $vhost_class ? {
    undef   => $zabbix::params::frontend_vhost_class,
    default => $vhost_class
  }
  $db_type_real     = $db_type ? {
    undef   => $zabbix::params::frontend_db_type,
    default => $db_type
  }
  $db_server_real   = $db_server ? {
    undef   => $zabbix::params::frontend_db_server,
    default => $db_server
  }
  $db_port_real     = $db_port ? {
    undef   => $zabbix::params::frontend_db_port,
    default => $db_port
  }
  $db_database_real = $db_database ? {
    undef   => $zabbix::params::frontend_db_database,
    default => $db_database
  }
  $db_user_real     = $db_user ? {
    undef   => $zabbix::params::frontend_db_user,
    default => $db_user
  }
  $db_password_real = $db_password ? {
    undef   => $zabbix::params::frontend_db_password,
    default => $db_password
  }

  if $::operatingsystem == 'Gentoo' {
    class { 'zabbix::frontend::gentoo':
      ensure => $ensure_real
    }
  }

  if $vhost_class_real != 'zabbix::puppet::vhost' {
    class { $vhost_class_real:
    }
  } else {
    class { 'zabbix::frontend::vhost':
      ensure   => $ensure_real,
      hostname => $hostname_real,
      before   => Webapp_config['zabbix']
    }

  }

  $webapp_action = $ensure_real ? {
    present => 'install',
    absent  => 'remove',
    default => noop
  }

  file { "/var/www/${hostname_real}/htdocs${base_real}/conf/zabbix.conf.php":
    ensure  => $ensure_real,
    content => template('zabbix/zabbix.conf.php.erb'),
    require => Webapp_config['zabbix']
  }

  if ($version_real != 'skip') {
    webapp_config { 'zabbix':
      action  => $webapp_action,
      vhost   => $hostname_real,
      version => $version_real,
      app     => 'zabbix',
      base    => $base_real,
      depends => []
    }
  }
}
