# == Class: zabbix::frontend
#
# Install and manage zabbix frontend
#
# === Parmeters
# [*ensure*]
#   absent or present
# [*version*]
#   ...
#
class zabbix::frontend ($ensure = undef, $version = undef) {
  include zabbix::params
  $ensure_real = $ensure ? {
    undef   => $zabbix::params::frontend_ensure,
    default => $ensure
  }
  validate_re($ensure_real, [absent, present])
  $version_real = $version ? {
    undef   => $zabbix::params::frontend_version,
    default => $version
  }
  validate_re($ensure_real, ['^[0-9].[0-9].[0-9]', present, absent, 'skip'])

  if $::operatingsystem == 'Gentoo' {
    class { 'zabbix::frontend::gentoo':
      ensure => $ensure_real
    }
  }

  class { 'zabbix::frontend::vhost':
    ensure => $ensure_real,
    before => Webapp_config['zabbix']
  }

  $webapp_action = $ensure_real ? {
    present => 'install',
    absent  => 'remove',
    default => noop
  }

  if ($version_real != 'skip') {
    webapp_config { 'zabbix':
      action  => $webapp_action,
      vhost   => $fqdn,
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
