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
  $zabbix_database_host     = ''
  $zabbix_database_type     = 'mysql'
  $zabbix_database_user     = 'root'
  $zabbix_database_password = ''

  $zabbix_frontend_url      = 'http://localhost/zabbix'
  $zabbix_frontend_user     = 'Admin'
  $zabbix_frontend_password = 'zabbix'

  case $::operatingsystem {
    windows         : {
      $zabbix_agentd_install          = false
      $zabbix_supports_userparameters = false
      $zabbix_agentd_service_name     = 'Zabbix Agent'
      $zabbix_agentd_conf_file        = 'C:\zabbix_agentd.conf'
      $zabbix_agentd_conf_template    = 'zabbix_agentd.win.conf.erb'
    }
    Debian          : {
      $zabbix_supports_userparameters = true
      $zabbix_agentd_install          = true
      $zabbix_agentd_package_name     = 'zabbix-agent'
      $zabbix_agentd_service_name     = 'zabbix-agent'
      $zabbix_agentd_conf_file        = '/etc/zabbix/zabbix_agent.conf'
      $zabbix_agentd_conf_template    = 'zabbix_agentd.conf.erb'
      $zabbix_agentd_conf_include     = '/etc/zabbix/zabbix_agentd.d/'
      $zabbix_agentd_pid_file         = '/var/run/zabbix-agent/zabbix_agentd.pid'
      $zabbix_agentd_log_file         = '/var/log/zabbix-agent/zabbix_agentd.log'
    }
    Gentoo, default : {
      $zabbix_supports_userparameters = true
      $zabbix_agentd_install          = true
      $zabbix_agentd_package_name     = 'zabbix'
      $zabbix_agentd_service_name     = 'zabbix-agentd'
      $zabbix_agentd_conf_file        = '/etc/zabbix/zabbix_agentd.conf'
      $zabbix_agentd_conf_template    = 'zabbix_agentd.conf.erb'
      $zabbix_agentd_conf_include     = '/etc/zabbix/userparameter.d/'
      $zabbix_agentd_pid_file         = '/var/run/zabbix/zabbix_agentd.pid'
      $zabbix_agentd_log_file         = '/var/log/zabbix/zabbix_agentd.log'
    }

  }

}
