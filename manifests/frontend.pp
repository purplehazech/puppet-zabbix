# == Class: zabbix::frontend
#
# Install and manage zabbix frontend
#
# === Parmeters
# * *ensure*
#   absent or present
# * *hostname*
#   what hostname webapp shall use
# * *vhost_class*
#    class to use as the main vhost class, use to
#    replace zabbix::frontend::vhost if needed
# * *version*
#   zabbix version or skip to leave out most of this module
#
class zabbix::frontend (
  $ensure      = undef,
  $hostname    = undef,
  $vhost_class = undef,
  $version     = undef) {
  include zabbix::params
  $ensure_real = $ensure ? {
    undef   => $zabbix::params::frontend_ensure,
    default => $ensure
  }
  validate_re($ensure_real, [absent, present])
  $hostname_real = $hostname ? {
    undef   => $zabbix::params::frontend_hostname,
    default => $hostname
  }
  validate_string($hostname_real)
  $version_real = $version ? {
    undef   => $zabbix::params::frontend_version,
    default => $version
  }
  validate_re($ensure_real, ['^[0-9].[0-9].[0-9]', present, absent, 'skip'])
  $vhost_class_real = $vhost_class ? {
    undef   => $zabbix::params::frontend_vhost_class,
    default => $vhost_class
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
      ensure => $ensure_real,
      before => Webapp_config['zabbix']
    }

  }

  $webapp_action = $ensure_real ? {
    present => 'install',
    absent  => 'remove',
    default => noop
  }

  if ($version_real != 'skip') {
    webapp_config { 'zabbix':
      action  => $webapp_action,
      vhost   => $hostname_real,
      version => $version_real,
      app     => 'zabbix',
      base    => '/zabbix',
      depends => []
    }
  }

  case $ensure {
    present : { # in /etc/php/apache2-php5.4/php.ini do
                #   date.timezone = Europe/Zurich
                #   post_max_size = 32M
                #   max_execution_time = 600
                #   max_input_time = 600
                # setup
                # /usr/share/webapps/zabbix/2.0.3/htdocs/include/db.inc.php
                #   $DB_TYPE='SQLITE3';
                #   $zabbix_database_* vars
                # webapp-config -I -h localhost -d zabbix zabbix 2.0.3
       }
    absent  : { }
  }

}
