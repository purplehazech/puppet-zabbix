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

  $basedir = "/var/www/${hostname}/htdocs${base}"

  if $conf_file == '' {
    $real_conf_file =  $::osfamily ? {
      'Debian' => '/etc/zabbix/web/zabbix.conf.php',
      default  => "${basedir}/conf/zabbix.conf.php"
    }
  } else {
    $real_conf_file = $conf_file
  }

  if ($version != 'skip') {
    if $::operatingsystem == 'Gentoo' {
      # Gentoo uses webapp-config
      webapp_config { 'zabbix':
        action  => $webapp_action,
        vhost   => $hostname,
        version => $version,
        app     => 'zabbix',
        base    => $base,
        depends => []
      }
    } else {
      #for others this might work.
      file { $basedir:
        ensure => link,
        target => '/usr/share/zabbix',
      }
    }
  }

  if $::operatingsystem == 'Gentoo' {
    $webapp_config = Webapp_config['zabbix']
  } else {
    $webapp_config = File[$basedir]
  }

  $install_package    = $::operatingsystem ? {
    windows => false,
    default => true,
  }

  if $vhost_class != 'zabbix::frontend::vhost' {
    class { $vhost_class:
    }
  } else {
    class { 'zabbix::frontend::vhost':
      ensure   => $ensure,
      hostname => $hostname,
      before   => $webapp_config
    }

  }

  $webapp_action = $ensure ? {
    present => 'install',
    absent  => 'remove',
    default => noop
  }

  file { $real_conf_file:
    ensure  => $ensure,
    content => template('zabbix/zabbix.conf.php.erb'),
    require => $webapp_config
  }

  if $install_package != false {
    package { $package:
      ensure => $ensure,
    }
    Package[$package] -> File[$real_conf_file]
  }
}
