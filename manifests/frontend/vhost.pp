# == Class: zabbix::frontend::vhost
#
class zabbix::frontend::vhost (
  $ensure    = lookup('frontend_ensure',   'Boolean', true),
  $vhostname = lookup('frontend_hostname', 'String',  $::fqdn),
  $docroot   = undef,
  $port      = lookup('frontend_port',     'String', '80'),
  $timezone  = lookup('frontend_timezone', 'String',  $timezone)
) {

  validate_bool($ensure)
  validate_string($vhostname)

  $docroot_real = $docroot ? {
    undef   => "/var/www/${vhostname}/htdocs",
    default => $docroot
  }
  validate_absolute_path($docroot_real)

  if ($ensure) {
    include apache

    apache::vhost { $vhostname:
      vhost_name => $vhostname,
      docroot    => $docroot_real,
      port       => $port,
      ssl        => false
    }

    apache::vhost::include::php { 'zabbix':
      vhost_name => $vhostname,
      values     => [
        "date.timezone \"${timezone}\"",
        'post_max_size "32M"',
        'max_execution_time "600"',
        'max_input_time "600"'
      ]
    }
  }
}
