# == Class: zabbix::agent
#
# Manage a zabbix agent
#
class zabbix::agent (
  $ensure             = undef,
  $hostname           = undef,
  $server             = undef,
  $listen_ip          = undef,
  $template           = undef,
  $conf_file          = undef,
  $pid_file           = undef,
  $log_file           = undef,
  $userparameters     = undef,
  $agent_include_path = undef,
  $package            = undef,
  $service_name       = undef) {
  include zabbix::params
  $ensure_real    = $ensure ? {
    undef   => $zabbix::params::agent_ensure,
    default => $ensure
  }
  $hostname_real  = $ensure ? {
    undef   => $zabbix::params::agent_hostname,
    default => $hostname
  }
  $server_ip_real = $server ? {
    undef   => $zabbix::params::server,
    default => $server
  }
  $listen_ip_real = $listen_ip ? {
    undef   => $zabbix::params::agent_listen_ip,
    default => $listen_ip
  }
  $template_real  = $template ? {
    undef   => $zabbix::params::agent_template,
    default => $template
  }
  $conf_file_real = $conf_file ? {
    undef   => $zabbix::params::agent_conf_file,
    default => $conf_file
  }
  $pid_file_real  = $pid_file ? {
    undef   => $zabbix::params::agent_pid_file,
    default => $pid_file
  }
  $log_file_real  = $log_file ? {
    undef   => $zabbix::params::agent_log_file,
    default => $log_file
  }
  $userparameters_real     = $userparameters ? {
    undef   => $zabbix::params::agent_userparameters,
    default => $userparameters
  }
  $has_userparameters      = $userparameters_real ? {
    undef   => false,
    default => true
  }
  $agent_include_path_real = $agent_include_path ? {
    undef   => $zabbix::params::agent_include_path,
    default => $agent_include_path
  }
  $package_real   = $package ? {
    undef   => $zabbix::params::agent_package,
    default => $package
  }
  $service_name_real       = $service_name ? {
    undef   => $zabbix::params::agent_service_name,
    default => $service_name
  }
  # compat: define stuff still used in win template
  $cn             = $hostname_real
  $ipHostNumber   = $listen_ip_real
  $zabbix_server_ip        = $server_ip_real
  $zabbix_agentd_pid_file  = $pid_file_real
  $zabbix_agentd_log_file  = $log_file_real
  $zabbix_agentd_install   = $ensure_real

  file { $conf_file_real:
    content => template("zabbix/${template_real}"),
    notify  => Service[$service_name_real];
  }

  if $ensure_real != false {
    package { $package_real:
      ensure => $ensure_real,
      before => File[$conf_file_real],
      notify => Servce[$service_name_real]
    }
  }
  $service_ensure = $ensure_real ? {
    present => running,
    default => stopped
  }
  $service_enable = $ensure_real ? {
    present => true,
    default => false
  }

  service { $service_name_real:
    ensure => $service_ensure,
    enable => $service_enable
  }

}
