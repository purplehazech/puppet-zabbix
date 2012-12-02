# == Class: zabbix:agent::params
#
define zabbix::agent::params ($ensure, $params) {
  if $zabbix::params::zabbix_supports_userparameters {
    file { $zabbix::params::zabbix_agentd_conf_include:
      ensure => directory,
      notify => Service[$zabbix::params::zabbix_agentd_service_name]
    }
  }

}
