# == Class: zabbix::params
#
# parametrize zabbix class
#
# === Operating Systems
#
# This module supports various operating systems.
#
# ==== Windows
#
# windows needs some pretty strange defaults, also most windowsy stuff is
# deactivated since i was to lazy to get it all up and running. We should
# try getting away from windows anyhow.
#
# * agent installation and userparemeters are disabled
# * config is in C:\zabbix_agentd.conf
#
# ==== Debian
#
# installs on its own and has a fully featured setup using debian specific
# paths where applicable.
#
# ==== Gentoo, default
#
# based on a oldish gentoo setup that could use some love. Also installs
# on its own and supports userparameters.
#
# === Example Usage
#
#   class zabbix::foot inherits zabbix::params
#
class zabbix::params {
  # global settings
  $ensure   = present
  $agent    = present
  $server   = absent
  $frontend = absent
  $api      = $::operatingsystem ? {
    windows => absent,
    default => present
  }
  # global network settings
  $server_host              = 'zabbix'

  # agent settings
  $agent_ensure             = present
  $agent_hostname           = $::operatingsystem ? {
    windows => $::cn, # grab name from ldap in unreliable windows case
    default => $::hostname
  }
  $agent_listen_ip          = $::ipHostNumber # from ldap
  $agent_userparameters     = undef # default install does not have userparams
  $agent_include_path       = '/etc/zabbix/zabbix_agentd.d'

  $agent_conf_file          = $::operatingsystem ? {
    windows => 'C:\zabbix_agentd.conf',
    Gentoo  => '/etc/zabbix/zabbix_agentd.conf',
    default => '/etc/zabbix/zabbix_agent.conf'
  }
  $agent_pid_file           = $::operatingsystem ? {
    Gentoo  => '/var/run/zabbix/zabbix_agentd.pid',
    default => '/var/run/zabbix-agent/zabbix_agentd.pid'
  }
  $agent_log_file           = $::operatingsystem ? {
    Gentoo  => '/var/log/zabbix/zabbix_agentd.log',
    default => '/var/log/zabbix-agent/zabbix_agentd.log'
  }
  $agent_template           = $::operatingsystem ? {
    windows => 'zabbix_agentd.win.conf.erb',
    default => 'zabbix_agentd.conf.erb'
  }
  $agent_package            = $::operatingsystem ? {
    windows => false,
    Gentoo  => 'zabbix',
    default => 'zabbix-agent'
  }
  $agent_service_name       = $::operatingsystem ? {
    windows => 'Zabbix Agent',
    Gentoo  => 'zabbix-agentd',
    default => 'zabbix-agent'
  }
  # agent_param settings
  $agent_param_ensure       = 'present'
  $agent_param_index        = '10'
  $agent_param_template     = 'zabbix/zabbix_agent_userparam.conf.erb'
  $agent_param_command      = 'echo "Hello World!"'

  # server settings
  $zabbix_database_host     = ''
  $zabbix_database_type     = 'mysql'
  $zabbix_database_user     = 'root'
  $zabbix_database_password = ''

  # frontend settings
  $frontend_ensure          = present
  $frontend_version         = $::operatingsystem ? {
    windows => false,
    default => '2.0.3'
  }
  $frontend_url             = 'http://localhost/zabbix'
  $frontend_user            = 'Admin'
  $frontend_password        = 'zabbix'

}