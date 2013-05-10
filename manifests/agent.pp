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
  $ensure             = hiera('agent_ensure', present),
  $hostname           = hiera('agent_hostname', $::hostname),
  $server             = hiera('server_hostname', 'zabbix'),
  $listen_ip          = hiera('agent_listen_ip', '0.0.0.0'),
  $template           = hiera('agent_template', 'zabbix/zabbix_agentd.conf.erb'),
  $conf_file          = hiera('agent_conf_file', '/etc/zabbix/zabbix_agentd.conf'),
  $pid_file           = hiera('agent_pid_file', '/var/run/zabbix/zabbix_agentd.pid'),
  $log_file           = hiera('agent_log_file', '/var/log/zabbix/zabbix_agentd.log'),
  $userparameters     = {},
  $agent_include_path = hiera('agent_include_path', '/etc/zabbix/zabbix_agentd.d'),
  $server_include_path= hiera('server_include_path', '/etc/zabbix/agent_server.conf'),
  $package            = hiera('agent_package', 'zabbix'),
  $service_name       = hiera('agent_service_name', 'zabbix-agentd')) {
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

  if $::operatingsystem == 'Gentoo' {
    class { 'zabbix::agent::gentoo':
      ensure => $ensure
    }
  }

  file { $agent_include_path:
    ensure => directory,
    mode   => '0500',
    owner  => 'zabbix',
    group  => 'zabbix'
  }
  
  Zabbix::Agent::Server <<| |>>
  
  file { $conf_file:
    content => template($template),
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
}
