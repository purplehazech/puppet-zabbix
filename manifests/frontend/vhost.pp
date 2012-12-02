# == Class: zabbix::frontend::vhost
#
class zabbix::frontend::vhost (
  $ensure  = undef,
  $docroot = undef,
  $port    = undef,
  $host    = undef) {
  include zabbix::params
  $ensure_real = $ensure ? {
    undef   => $zabbix::params::frontend,
    default => $ensure
  }
  validate_re($ensure_real, [absent, present])
  $docroot_real = $docroot ? {
    undef   => $zabbix::params::frontend_docroot,
    default => $docroot
  }
  validate_absolute_path($docroot_real)
  $port_real = $port ? {
    undef   => $zabbix::params::frontend_port,
    default => $port
  }
  $host_real = $host ? {
    undef   => $zabbix::params::frontend_host,
    default => $host
  }

  include apache

  apache::vhost { $host_real:
    vhost_name => $host_real,
    docroot    => $docroot_real,
    port       => $port_real,
  }

}
