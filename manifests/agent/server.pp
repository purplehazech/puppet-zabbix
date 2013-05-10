# == Define: zabbix::agent::server
#
# server helper define
#
define zabbix::agent::server (
  $ensure       = hiera('agent_server_ensure', present),
  $hostname     = hiera('agent_server_hostanme', 'zabbix'),
  $port         = hiera('agent_server_port', 10051),
  $include_path = hiera('server_include_path', '/etc/zabbix/agent_server.conf')
) {
  
  file { $include_path: 
    content => template('zabbix/zabbix_agent_server_include.conf.erb')
  }
}
