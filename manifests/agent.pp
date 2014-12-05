# == Class: zabbix::agent
#
# Install and manage a zabbix agent. Have a look at zabbix::agent::param if you
# need to use custom UserParameters.
#
# === Parameters
# [*ensure*]
#  present, absent to use package manager or false to disable package resource
# [*hostname*]
#  hostname to report as
# [*server*]
#  server to send reports to
# [*use_api*]
#  enable use of api, default = true
# [*use_ipv4*]
#  use ipv4, default = true
# [*use_ipv6*]
#  use ipv6, default = true
# [*listen_ipv4*]
#  ipv4 to to listen on
# [*listen_ipv6*]
#  ipv6 to to listen on
# [*source_ipv4*]
#  ipv4 to to use as source, overrides source_ipv6
# [*source_ipv6*]
#  ipv6 to to use as source
# [*template*]
#  what template to use
# [*conf_file*]
#  where to put agent config
# [*pid_file*]
#  where the pid file lives
# [*log_file*]
#  what file to log to
# [*userparameters*]
#  Hash of default userparmeters, unsupported
# [*agent_include_path*]
#  needed for user parameters, specify default userparameter location, might
#  get folded into userparameter
# [*package*]
#  name of package to install
# [*service_name*]
#  name of service to start
# [*groups*]
#  the groups the agent should be in in zabbix
#
# === Example Usage:
#
# install and manage zabbix::agent
#
#   class { 'zabbix::agent' :
#     server => 'zabbix'
#   }
#
# only manage zabbix, dont install (handy on windows)
#
#   class { 'zabbix::agent' :
#     server  => 'zabbix',
#     package => false
#   }
#
# === Issues
#
# * only really tested on gentoo, some debian flavors and partly on some winxp
#
class zabbix::agent (
  $ensure             = lookup('agent_ensure',         'Boolean'),
  $hostname           = lookup('agent_hostname',       'String' ),
  $server             = lookup('server_hostname',      'String' ),
  $use_api            = lookup('use_api',              'Boolean'),
  $use_ipv4           = lookup('use_ipv4',             'Boolean'),
  $use_ipv6           = lookup('use_ipv4',             'Boolean'),
  $listen_ipv4        = lookup('agent_listen_ipv4',    'String' ),
  $listen_ipv6        = lookup('agent_listen_ipv6',    'String' ),
  $source_ipv4        = lookup('agent_source_ipv4',    'String' ),
  $source_ipv6        = lookup('agent_source_ipv6',    'String' ),
  $template           = lookup('agent_template',       'String' ),
  $conf_file          = lookup('agent_conf_file',      'String' ),
  $pid_file           = lookup('agent_pid_file',       'String' ),
  $log_file           = lookup('agent_log_file',       'String' ),
  $userparameters     = lookup('agent_userparameters'           ),
  $agent_include_path = lookup('agent_include_path',   'String' ),
  $server_include_path= lookup('server_include_path',  'String' ),
  $package            = lookup('agent_package',        'String' ),
  $service_name       = lookup('agent_service_name',   'String' ),
  $groups             = lookup('agent_groups',         'Array'  ),
  $include            = lookup('agent_include',        'String' )
) {

  validate_bool($ensure)
  validate_absolute_path($conf_file)
  validate_absolute_path($pid_file)
  validate_absolute_path($pid_file)
  validate_hash($userparameters)

  # prepare ipv4/6 ips
  if $use_ipv6 and $use_ipv4 {
    $listen_ip = "${listen_ipv4},${listen_ipv6}"
  } elsif $use_ipv6 {
    $listen_ip = $listen_ipv6
  } else {
    $listen_ip = $listen_ipv4
  }
  $source_ip = $use_ipv6 ? {
    true    => $source_ipv6,
    default => $source_ipv4
  }

  if ($include != '') {
    include $include
  }

  file { $agent_include_path:
    ensure => directory,
    mode   => '0500',
    owner  => 'zabbix',
    group  => 'zabbix'
  }

  # pull in configuration exported by server
  Zabbix::Agent::Server <<| |>>

  file { $conf_file:
    content => template($template),
    notify  => Service[$service_name]
  }

  $service_ensure = $ensure ? {
    true    => running,
    present => running,
    default => stopped
  }
  $service_enable = $ensure ? {
    true    => true,
    present => true,
    default => false
  }

  service { $service_name:
    ensure => $service_ensure,
    enable => $service_enable
  }

  File[$agent_include_path] ~> File[$conf_file] ~> Service[$service_name]

  $package_ensure = $ensure ? {
    true  => installed,
    false => absent
  }

  package { $package:
    ensure => $package_ensure,
  }

  Package[$package] -> File[$conf_file]

  if ($use_api) {
    @@zabbix_host { $::fqdn:
      ip     => $source_ip,
      groups => $groups
    }
    @@zabbix_host_interface { "${::fqdn}_default_ipv4":
      host    => $::fqdn,
      ip      => $::ipaddress,
      dns     => $::fqdn,
      require => Zabbix_host[$::fqdn]
    }
    if $::ipaddress6 {
      @@zabbix_host_interface { "${::fqdn}_default_ipv6":
        host    => $::fqdn,
        ip      => $::ipaddress6,
        dns     => $::fqdn,
        require => Zabbix_host[$::fqdn]
      }
    }
  }
}
