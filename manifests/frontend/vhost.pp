# == Class: zabbix::frontend::vhost
#
class zabbix::frontend::vhost (
  $ensure   = undef,
  $hostname = undef,
  $docroot  = undef,
  $port     = undef) {
  include zabbix::params
  $ensure_real = $ensure ? {
    undef   => $zabbix::params::frontend,
    default => $ensure
  }
  validate_re($ensure_real, [absent, present])
  $hostname_real = $hostname ? {
    undef   => $zabbix::params::frontend_hostname,
    default => $hostname
  }
  validate_string($hostname_real)

  if $hostname_real == $zabbix::params::frontend_hostname {
    $config_docroot = $zabbix::params::frontend_docroot
  } else {
    $config_docroot = "/var/www/${hostname_real}/htdocs"
  }
  $docroot_real = $docroot ? {
    undef   => $config_docroot,
    default => $docroot
  }
  validate_absolute_path($docroot_real)
  $port_real = $port ? {
    undef   => $zabbix::params::frontend_port,
    default => $port
  }

  include apache

  apache::vhost { $hostname_real:
    vhost_name => $hostname_real,
    docroot    => $docroot_real,
    port       => $port_real,
    ssl        => false
  }

  apache::vhost::include::php { 'zabbix':
    vhost_name => $hostname_real,
    values     => [
      "date.timezone \"${::timezone}\"",
      'post_max_size "32M"',
      'max_execution_time "600"',
      'max_input_time "600"']
  }
}
