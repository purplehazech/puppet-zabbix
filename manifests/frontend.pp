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
  $ensure      = lookup('frontend_ensure',      'Boolean'),
  $server_host = lookup('server_hostname',      'String' ),
  $server_name = lookup('server_name',          'String' ),
  $hostname    = lookup('frontend_hostname',    'String' ),
  $base        = lookup('frontend_base',        'String' ),
  $vhost_class = lookup('frontend_vhost_class', 'String' ),
  $version     = lookup('version',              'String' ),
  $package     = lookup('frontend_package',     'String' ),
  $conf_file   = lookup('frontend_conf_file',   'String' ),
  $db_type     = lookup('db_type',              'String' ),
  $db_server   = lookup('db_server',            'String' ),
  $db_port     = lookup('db_port',              'Integer'),
  $db_database = lookup('db_database',          'String' ),
  $db_user     = lookup('db_user',              'String' ),
  $db_password = lookup('db_password',          'String' ),
  $include     = lookup('frontend_include',     'String' ),
  $timezone    = lookup('frontend_timezone',    'String' )
) {

  if ($include != '') {
    include $include
  }
  if ($vhost_class != '') {
    include $vhost_class
  }

  file { $conf_file:
    ensure  => $ensure,
    content => template('zabbix/zabbix.conf.php.erb')
  }

  package { $package:
    ensure => $ensure,
    onlyif => $package != '',
    before => File[$conf_file],
  }
}
