# == Class: zabbix::frontend::vhost
#
class zabbix::frontend::vhost (
  $ensure   = undef,
  $docroot  = undef,
  $port     = undef,
  $hostname = undef) {
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
  $host_real = $hostname ? {
    undef   => $zabbix::params::frontend_hostname,
    default => $hostname
  }

  include apache

  apache::vhost { $host_real:
    vhost_name => $host_real,
    docroot    => $docroot_real,
    port       => $port_real,
    ssl        => false
  }

  apache::vhost::include::php { 'zabbix':
    vhost_name => $host_real,
    values     => [
      "date.timezone \"${timezone}\"",
      'post_max_size "32M"',
      'max_execution_time "600"',
      'max_input_time "600"']
  }
}
