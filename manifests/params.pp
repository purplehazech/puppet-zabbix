# == Class: zabbix::params
#
# The zabbix configuration settings.
#
class zabbix::params {
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
  $reports_host                = hiera(
    'reports_host', lookup('server_hostname', 'String'))
  $reports_port                = hiera('reports_port', '10051')
  $reports_sender              = hiera(
    'reports_sender',
    '/usr/bin/zabbix_sender'
  )
}

