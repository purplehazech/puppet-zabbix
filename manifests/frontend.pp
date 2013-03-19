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
# [*ensure*]
#  absent or present
# [*server_host*]
#  the zabbix server this belongs to
# [*server_name*]
#  name as defined in zabbix
# [*hostname*]
#  what hostname webapp shall use
# [*vhost_class*]
#  class to use as the main vhost class, use to
#  replace zabbix::frontend::vhost if needed
# [*version*]
#  zabbix version or skip to leave out most of this module
# [*base*]
#  base path for web request_uri
#
class zabbix::frontend (
  $ensure      = $zabbix::params::frontend_ensure,
  $server_host = $zabbix::params::server_hostname,
  $server_name = $zabbix::params::server_name,
  $hostname    = $zabbix::params::frontend_hostname,
  $base        = $zabbix::params::frontend_base,
  $vhost_class = $zabbix::params::frontend_vhost_class,
  $version     = $zabbix::params::version,
  $db_type     = $zabbix::params::db_type,
  $db_server   = $zabbix::params::db_server,
  $db_port     = $zabbix::params::db_port,
  $db_database = $zabbix::params::db_database,
  $db_user     = $zabbix::params::db_user,
  $db_password = $zabbix::params::db_password) inherits zabbix::params  {
  validate_re($ensure, [absent, present])
  validate_string($server_host)
  validate_string($server_name)
  validate_string($hostname)
  validate_re($ensure, ['^[0-9].[0-9].[0-9]', present, absent, 'skip'])
  
  case $::operatingsystem {
    'Gentoo' : {
      class { 'zabbix::frontend::gentoo':
        ensure => $ensure
      }
    }
    'Debian' : {
      include zabbix::debian
    }
  }

  if $vhost_class != 'zabbix::frontend::vhost' {
    class { $vhost_class:
    }
  } else {
    #
    class { 'zabbix::frontend::vhost':
      ensure   => $ensure,
      hostname => $hostname,
      before   => Webapp_config['zabbix']
    }

  }

  $webapp_action = $ensure ? {
    present => 'install',
    absent  => 'remove',
    default => noop
  }

  file { "/var/www/${hostname}/htdocs${base}/conf/zabbix.conf.php":
    ensure  => $ensure,
    content => template('zabbix/zabbix.conf.php.erb'),
    require => Webapp_config['zabbix']
  }

  if ($version != 'skip') {
    webapp_config { 'zabbix':
      action  => $webapp_action,
      vhost   => $hostname,
      version => $version,
      app     => 'zabbix',
      base    => $base,
      depends => []
    }
  }
}
