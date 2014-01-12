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
# [*listen_ip*]
#  ip to to listen on, also gets used as source ip
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
  $ensure             = $zabbix::params::agent_ensure,
  $hostname           = $zabbix::params::agent_hostname,
  $server             = $zabbix::params::server_hostname,
  $listen_ip          = $zabbix::params::agent_listen_ip,
  $source_ip          = $zabbix::params::agent_source_ip,
  $template           = $zabbix::params::agent_template,
  $conf_file          = $zabbix::params::agent_conf_file,
  $pid_file           = $zabbix::params::agent_pid_file,
  $log_file           = $zabbix::params::agent_log_file,
  $userparameters     = $zabbix::params::userparameters,
  $agent_include_path = $zabbix::params::agent_include_path,
  $server_include_path= $zabbix::params::server_include_path,
  $package            = $zabbix::params::agent_package,
  $service_name       = $zabbix::params::agent_service_name
) inherits zabbix::params {

  validate_re($ensure, [absent, present])
  validate_absolute_path($conf_file)
  validate_absolute_path($pid_file)
  validate_absolute_path($pid_file)
  validate_hash($userparameters)

  $has_userparameters = $::operatingsystem ? {
    windows => false,
    default => true,
  }

  $install_package    = $::operatingsystem ? {
    windows => false,
    default => true,
  }

  case $::operatingsystem {
    'Gentoo' : {
      class { 'zabbix::agent::gentoo':
        ensure => $ensure
      }
    }
    'Debian','Ubuntu' : {
      include zabbix::debian
    }
    default : {
      # ignore unknown boxen
    }
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
    present => running,
    default => stopped
  }
  $service_enable = $ensure ? {
    present => true,
    default => false
  }

  service { $service_name:
    ensure => $service_ensure,
    enable => $service_enable
  }

  File[$agent_include_path] ~> File[$conf_file] ~> Service[$service_name]

  if $install_package != false {
    package { $package:
      ensure => $ensure,
    }
    Package[$package] -> File[$conf_file]
  }

  zabbix_host_interface { 'default_ipv4':
    host => $::fqdn,
    ip   => $::ipaddress,
    dns  => $::fqdn
  }

  zabbix_host_interface { 'default_ipv6':
    host => $::fqdn,
    ip   => $::ipaddress6,
    dns  => $::fqdn
  }

}
