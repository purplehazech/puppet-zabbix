# == Define: zabbix::agent::server
#
# server helper define
#
define zabbix::agent::server (
  $ensure   = hiera('agent_server_ensure', present),
  $hostname = hiera('agent_server_hostanme', 'zabbix')) {

}
