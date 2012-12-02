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
class zabbix::frontend ($ensure, $version = undef) {
  if $::operatingsystem == 'Gentoo' {
    class { 'zabbix::frontend::gentoo':
      ensure => $ensure
    }
  }
  $version_real  = $version ? {
    undef   => '0.0.0',
    default => $version
  }

  $webapp_action = $ensure ? {
    present => 'install',
    absent  => 'remove',
    default => noop
  }

  if ($version_real != '0.0.0') {
    webapp_config { 'zabbix':
      action  => $webapp_action,
      vhost   => $fqdn,
      version => $version_real,
      app     => 'zabbix',
      base    => '/zabbix',
      depends => ''
    }
    class { 'zabbix::frontend::vhost': 
      ensure => $ensure
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
