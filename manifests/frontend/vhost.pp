# == Class: zabbix::frontend::vhost
#
class zabbix::frontend::vhost (
  $ensure   = hiera('frontend_enable', present),
  $hostname = hiera('frontend_hostname', $::fqdn),
  $docroot  = undef,
  $port     = hiera('frontend_port', '80')) {
  validate_re($ensure, [absent, present])
  validate_string($hostname)

  $docroot_real = $docroot ? {
    undef   => "/var/www/${hostname}/htdocs",
    default => $docroot
  }
  validate_absolute_path($docroot_real)
  
  if ($ensure == present) {
    include apache

    apache::vhost { $hostname:
      vhost_name => $hostname,
      docroot    => $docroot_real,
      port       => $port,
      ssl        => false
    }

    apache::vhost::include::php { 'zabbix':
      vhost_name => $hostname,
      values     => [
        "date.timezone \"${::timezone}\"",
        'post_max_size "32M"',
        'max_execution_time "600"',
        'max_input_time "600"']
    }
  }
}
