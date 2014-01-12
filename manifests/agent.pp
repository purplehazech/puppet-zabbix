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
  $ensure             = hiera('zabbix_agent_ensure', present),
  $hostname           = hiera('zabbix_agent_hostname', $::hostname),
  $server             = hiera('zabbix_server_hostname', 'zabbix'),
  $use_ipv4           = hiera('use_ipv4', true),
  $use_ipv6           = hiera('use_ipv4', true),
  $listen_ipv4        = hiera('zabbix_agent_listen_ipv4', $::ipaddress),
  $listen_ipv6        = hiera('zabbix_agent_listen_ipv6', $::ipaddress6),
  $source_ipv4        = hiera('zabbix_agent_source_ipv4', $::ipaddress),
  $source_ipv6        = hiera('zabbix_agent_source_ipv6', $::ipaddress6),
  $template           = hiera(
    'zabbix_agent_template', 'zabbix/zabbix_agentd.conf.erb'),
  $conf_file          = hiera(
    'zabbix_agent_conf_file', '/etc/zabbix/zabbix_agentd.conf'),
  $pid_file           = hiera(
    'zabbix_agent_pid_file', '/var/run/zabbix/zabbix_agentd.pid'),
  $log_file           = hiera(
    'zabbix_agent_log_file', '/var/log/zabbix/zabbix_agentd.log'),
  $userparameters     = hiera('zabbix_userparameters', {}),
  $agent_include_path = hiera(
    'zabbix_agent_include_path', '/etc/zabbix/zabbix_agentd.d'),
  $server_include_path= hiera(
    'zabbix_server_include_path', '/etc/zabbix/agent_server.conf'),
  $package            = hiera2('zabbix_agent_package', 'zabbix-agent'),
  $service_name       = hiera2('zabbix_agent_service_name', 'zabbix-agent'),
  $groups             = hiera2('zabbix_agent_groups', [])) {
  validate_re($ensure, [absent, present])
  validate_absolute_path($conf_file)
  validate_absolute_path($pid_file)
  validate_absolute_path($pid_file)
  validate_hash($userparameters)

  # prepare ipv4/6
  if $use_ipv6 and $use_ipv4 {
    $listen_ip = "${listen_ipv4},${listen_ipv6}"
  } elsif $use_ipv6 {
    $listen_ip = $listen_ipv6
  } else {
    $listen_ip = $listen_ipv4
  }
  $source_ip             = $use_ipv6 ? {
    true    => hiera('agent_source_ip', $source_ipv6),
    default => hiera('agent_source_ip', $source_ipv4)
  }

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
    host    => $::fqdn,
    ip      => $::ipaddress,
    dns     => $::fqdn,
    require => Zabbix_host[$::fqdn]
  }

  zabbix_host_interface { 'default_ipv6':
    host    => $::fqdn,
    ip      => $::ipaddress6,
    dns     => $::fqdn,
    require => Zabbix_host[$::fqdn]
  }

  zabbix_host { $::fqdn:
    ip     => $source_ip,
    groups => $groups
  }

}
