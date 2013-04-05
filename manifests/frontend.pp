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
  $ensure      = hiera('frontend_enable', 'present'),
  $server_host = hiera('server_hostname', 'zabbix'),
  $server_name = hiera('server_name', 'Zabbix Server'),
  $hostname    = hiera('frontend_hostname', $::fqdn),
  $base        = hiera('frontend_base', '/zabbix'),
  $version     = hiera('version', $::zabbixversion),
  $db_type     = hiera('db_type', 'MYSQL'),
  $db_server   = hiera('db_server', 'localhost'),
  $db_port     = hiera('db_port', '0'),
  $db_database = hiera('db_database', 'zabbix'),
  $db_user     = hiera('db_user', 'root'),
  $db_password = hiera('db_password', '')) {
  validate_re($ensure, [absent, present])
  validate_string($server_host)
  validate_string($server_name)
  validate_string($hostname)
  validate_re($ensure, ['^[0-9].[0-9].[0-9]', present, absent, 'skip'])

  class { 'zabbix::frontend::gentoo':
    ensure => $ensure
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
