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
  # == facter imports
  #
  # grab vars from facter
  #
  # === zabbixversion_fact
  #
  # grab version from facter, this might fix poor broken travis
  $zabbixversion_fact   = $::zabbixversion ? {
    undef   => '2.0.3', # golden default that needs updating
    default => $::zabbixversion # the real thang
  }

  # == global settings
  $ensure               = present
  $agent                = present
  $server               = absent
  $frontend             = absent
  $api                  = $::operatingsystem ? {
    windows => absent,
    default => present
  }
  $db_type              = 'MYSQL'
  $db_server            = 'localhost'
  $db_port              = '0'
  $db_database          = 'zabbix'
  $db_user              = 'root'
  $db_password          = ''
  # global network settings
  $server_host          = 'zabbix'

  # agent settings
  $agent_ensure         = present
  $agent_hostname       = $::operatingsystem ? {
    windows => $::cn, # grab name from ldap in unreliable windows case
    default => $::hostname
  }
  $agent_listen_ip      = $::ipHostNumber # from ldap
  $agent_userparameters = undef # default install does not have userparams
  $agent_include_path   = '/etc/zabbix/zabbix_agentd.d'

  $agent_conf_file      = $::operatingsystem ? {
    windows => 'C:\zabbix_agentd.conf',
    Gentoo  => '/etc/zabbix/zabbix_agentd.conf',
    default => '/etc/zabbix/zabbix_agent.conf'
  }
  $agent_pid_file       = $::operatingsystem ? {
    Gentoo  => '/var/run/zabbix/zabbix_agentd.pid',
    default => '/var/run/zabbix-agent/zabbix_agentd.pid'
  }
  $agent_log_file       = $::operatingsystem ? {
    Gentoo  => '/var/log/zabbix/zabbix_agentd.log',
    default => '/var/log/zabbix-agent/zabbix_agentd.log'
  }
  $agent_template       = $::operatingsystem ? {
    windows => 'zabbix_agentd.win.conf.erb',
    default => 'zabbix_agentd.conf.erb'
  }
  $agent_package        = $::operatingsystem ? {
    windows => false,
    Gentoo  => 'zabbix',
    default => 'zabbix-agent'
  }
  $agent_service_name   = $::operatingsystem ? {
    windows => 'Zabbix Agent',
    Gentoo  => 'zabbix-agentd',
    default => 'zabbix-agent'
  }
  # agent_param settings
  $agent_param_ensure   = 'present'
  $agent_param_index    = '10'
  $agent_param_template = 'zabbix/zabbix_agent_userparam.conf.erb'
  $agent_param_command  = 'echo "Hello World!"'

  # == server settings
  #
  # settings for the server, if enabled
  #
  # === server_enable
  #
  # install and manage server, present, absent
  $server_enable        = present

  # == server_conf_file
  #
  # config file for server
  #
  $server_conf_file     = '/etc/zabbix/zabbix_server.conf'

  # == server_template
  #
  # template for conf file
  #
  $server_template      = 'zabbix/zabbix_server.conf.erb'
  #
  # == server_node_id
  #
  # node id for multi master setups
  #
  $server_node_id       = 0
  $server_db_server     = $db_server
  $server_db_database   = $db_database
  $server_db_user       = $db_user
  $server_db_password   = $db_password

  # == frontend settings
  #
  # contains setting pertaining to the front end install
  #
  # === frontend_ensure
  #
  # install frontend on node, present or absent
  #
  $frontend_ensure      = present

  # === frontend_vhost_class
  #
  # What class to use for creating vhosts. The provided default
  # creates an apache base server and hosts zabbix on /zabbix.
  #
  $frontend_vhost_class = 'zabbix::puppet::vhost'

  # === frontend_version
  #
  # what version of the frontend to install, skip make this module ignore
  # everything.
  #
  # @todo find a friendly way to get the answer from webapp-config and implement
  #       said thing nicely
  #
  $frontend_version     = $::operatingsystem ? {
    windows => 'skip',
    default => $zabbixversion_fact
  }

  # === frontend_node
  #
  # under what fqdn this will get hosted
  #
  $frontend_hostname    = $fqdn

  # === frontend_docroot
  #
  # docroot of the frontends vhost
  #
  $frontend_docroot     = "/var/www/${frontend_hostname}/htdocs"

  # === frontend_base
  #
  # base request uri for frontend
  #
  $frontend_base        = '/zabbix'
  $frontend_port        = '80'
  $frontend_url         = "http://${frontend_hostname}/zabbix"
  $frontend_user        = 'Admin'
  $frontend_password    = 'zabbix'
  $frontend_db_type     = $db_type
  $frontend_db_server   = $db_server
  $frontend_db_port     = $db_port
  $frontend_db_database = $db_database
  $frontend_db_user     = $db_user
  $frontend_db_password = $db_password
}
