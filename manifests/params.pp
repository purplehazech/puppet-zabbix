# == Class: zabbix::params
#
# The zabbix configuration settings.
#
class zabbix::params {
  $default_agent_package =  $::osfamily ? {
    'Debian' => 'zabbix-agent',
    default  => 'zabbix'
  }
  
  $default_agent_service_name =  $::osfamily ? {
    'Debian' => 'zabbix-agent',
    default  => 'zabbix-agentd'
  }

  #agent parameters
  $agent_ensure                = hiera('agent_ensure', present)
  $agent_hostname              = hiera('agent_hostname', $::hostname)
  $agent_listen_ip             = hiera('agent_listen_ip', '0.0.0.0')
  $agent_template              = hiera('agent_template', 'zabbix/zabbix_agentd.conf.erb')
  $agent_conf_file             = hiera('agent_conf_file', '/etc/zabbix/zabbix_agentd.conf')
  $agent_pid_file              = hiera('agent_pid_file', '/var/run/zabbix/zabbix_agentd.pid')
  $agent_log_file              = hiera('agent_log_file', '/var/log/zabbix/zabbix_agentd.log')
  $agent_include_path          = hiera('agent_include_path', '/etc/zabbix/zabbix_agentd.d')
  $agent_package               = hiera('agent_package', $default_agent_package)
  $agent_service_name          = hiera('agent_service_name', $default_agent_service_name)
  $userparameters              = {}
  
  #server parameters
  $server_hostname             = hiera('server_hostname', 'zabbix')
  $server_name                 = hiera('server_name', 'Zabbix Server')
  $server_include_path         = hiera('server_include_path', '/etc/zabbix/agent_server.conf')
  $server_conf_file            = hiera('server_conf_file', '/etc/zabbix/zabbix_server.conf')
  $server_template             = hiera('server_template', 'zabbix/zabbix_server.conf.erb')
  $server_node_id              = hiera('server_node_id', 0)
  $server_ensure               = hiera('server_enable', present)
  
  #frontent parameters
  $frontend_ensure             = hiera('frontend_enable', 'present')
  $frontend_hostname           = hiera('frontend_hostname', $::fqdn)
  $frontend_base               = hiera('frontend_base', '/zabbix')
  $frontend_vhost_class        = hiera('frontend_vhost_class', 'zabbix::frontend::vhost')
  
  #common parameters
  $version                     = hiera('version', $::zabbixversion)
  $db_type                     = hiera('db_type', 'MYSQL')
  $db_server                   = hiera('db_server', 'localhost')
  $db_port                     = hiera('db_port', '0')
  $db_database                 = hiera('db_database', 'zabbix')
  $db_user                     = hiera('db_user', 'root')
  $db_password                 = hiera('db_password', '')
  
  #zabbix base class parameters
  $ensure                      = hiera('ensure', present)
  $agent                       = hiera('agent', present)
  $server                      = hiera('server', absent)
  $frontend                    = hiera('frontend', absent)
  $api                         = hiera('api', present)
  $export                      = hiera('export', present)
}
