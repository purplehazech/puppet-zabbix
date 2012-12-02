# == Class: zabbix::agent
#
# Manage a zabbix agent
#
class zabbix::agent {
  $template = "zabbix/${zabbix::params::zabbix_agentd_conf_template}"

  file { $zabbix::params::zabbix_agentd_conf_file:
    content => template($template),
    notify  => Service[$zabbix::params::zabbix_agentd_service_name];
  }

  if $zabbix::params::zabbix_agentd_install {
    package { $zabbix::params::zabbix_agentd_package_name:
      ensure => installed,
      before => File[$zabbix::params::zabbix_agentd_conf_file]
    }
    $packagename            = $zabbix::params::zabbix_agentd_package_name
    $zabbix_service_require = Package[$packagename]
  }

  service { $zabbix::params::zabbix_agentd_service_name:
    ensure  => running,
    require => $zabbix_service_require
  }

}
