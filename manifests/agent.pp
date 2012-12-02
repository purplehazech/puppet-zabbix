# == Class: zabbix::agent
#
# Manage a zabbix agent
#
class zabbix::agent (
  $hostname           = $::hostname,
  $server             = undef,
  $listen_ip          = undef,
  $pid_file           = undef,
  $log_file           = undef,
  $userparameters     = undef,
  $agent_include_path = undef) {
  include zabbix::params
  $server_ip_real = $server ? {
    undef   => $zabbix::params::server,
    default => $server
  }
  $listen_ip_real = $listen_ip ? {
    undef   => $zabbix::params::agent_listen_ip,
    default => $listen_ip
  }
  $pid_file_real  = $pid_file ? {
    undef   => $zabbix::params::agent_pid_file,
    default => $pid_file
  }
  $log_file_real  = $log_file ? {
    undef   => $zabbix::params::agent_log_file,
    default => $log_file
  }
  $userparameters_real            = $userparameters ? {
    undef   => $zabbix::params::agent_userparameters,
    default => $userparameters
  }
  $has_userparameters             = $userparameters_real ? {
    undef   => false,
    default => true
  }
  $agent_include_path_real        = $agent_include_path ? {
    undef   => $zabbix::params::agent_include_path,
    default => $agent_include_path
  }
  # compat: define stuff still used in win template
  $zabbix_server_ip               = $server_ip_real
  $ipHostNumber   = $listen_ip_real
  $zabbix_agentd_pid_file         = $pid_file_real
  $zabbix_agentd_log_file         = $log_file_real
  $zabbix_supports_userparameters = $has_userparameters

  $template       = "zabbix/${zabbix::params::zabbix_agentd_conf_template}"

  file { $zabbix::params::zabbix_agentd_conf_file:
    content => template($template),
    notify  => Service[$zabbix::params::zabbix_agentd_service_name];
  }

  if $zabbix::params::zabbix_agentd_install {
    package { $zabbix::params::zabbix_agentd_package_name:
      ensure => installed,
      before => File[$zabbix::params::zabbix_agentd_conf_file]
    }
    $packagename            = $zabbix::params::zabbix_agentd_package_name
    $zabbix_service_require = Package[$packagename]
  }

  service { $zabbix::params::zabbix_agentd_service_name:
    ensure  => running,
    require => $zabbix_service_require
  }

}

