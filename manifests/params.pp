# == Class: zabbix::params
#
# The zabbix configuration settings.
#
class zabbix::params {

  # @todo refactor into hiera2
  $default_agent_package =  $::osfamily ? {
    'Debian' => 'zabbix-agent',
    default  => 'zabbix'
  }
  $default_agent_service_name =  $::osfamily ? {
    'Debian' => 'zabbix-agent',
    default  => 'zabbix-agentd'
  }
  $agent_groups       = hiera('agent_groups', ['Linux servers'])

  #server parameters
  $server_hostname     = hiera('server_hostname', 'zabbix')
  $server_name         = hiera('server_name', 'Zabbix Server')
  $server_include_path = hiera(
    'server_include_path',
    '/etc/zabbix/agent_server.conf'
  )
  $server_conf_file    = hiera(
    'server_conf_file',
    '/etc/zabbix/zabbix_server.conf'
  )
  $server_template     = hiera(
    'server_template',
    'zabbix/zabbix_server.conf.erb'
  )
  $server_node_id      = hiera('server_node_id', 0)
  $server_ensure       = hiera('server_enable', present)
  $server_package      = hiera('server_enable', '')

  #frontend parameters
  $frontend_ensure      = hiera('frontend_enable', 'present')
  $frontend_hostname    = hiera('frontend_hostname', $::fqdn)
  $frontend_base        = hiera('frontend_base', '/zabbix')
  $frontend_vhost_class = hiera(
    'frontend_vhost_class',
    'zabbix::frontend::vhost'
  )
  $frontend_package     = hiera('frontend_package', 'zabbix-frontend-php')
  $frontend_conf_file   = hiera('frontend_conf_file', '')
  $frontend_port        = hiera('frontend_port', '80')
  $frontend_timezone    = hiera('frontend_timezone', $::timezone)

  #api parameters
  $api_ensure                  = hiera('api_enable', 'present')
  $api_url                     = hiera(
    'api_url',
    'https://zabbix/api_jsonrpc.php'
  )
  $api_username                = hiera('api_username', $api_http_username)
  $api_password                = hiera('api_username', $api_http_password)
  $api_http_username           = hiera('api_username', false)
  $api_http_password           = hiera('api_username', false)
  $api_debug                   = hiera('api_debug', false)


  #reports parameters
  $reports_ensure              = hiera('reports_enable', 'present')
  $reports_host                = hiera('reports_host', $server_hostname)
  $reports_port                = hiera('reports_port', '10051')
  $reports_sender              = hiera(
    'reports_sender',
    '/usr/bin/zabbix_sender'
  )

  #common parameters
  $version     = hiera('version', $::zabbixversion)
  $db_type     = hiera('db_type', 'MYSQL')
  $db_server   = hiera('db_server', 'localhost')
  $db_port     = hiera('db_port', '0')
  $db_database = hiera('db_database', 'zabbix')
  $db_user     = hiera('db_user', 'root')
  $db_password = hiera('db_password', '')

  #zabbix base class parameters
  $ensure   = hiera('ensure', present)
  $agent    = hiera('agent', present)
  $server   = hiera('server', absent)
  $frontend = hiera('frontend', absent)
  $api      = hiera('api', present)
  $reports  = hiera('reports', absent)
  $export   = hiera('export', present)
}

