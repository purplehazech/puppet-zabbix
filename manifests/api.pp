# == Class: zabbix::api
#
# Install and manage a zabbix library. It enables you to use zabbix in puppet.
#
# === Parameters
# [*ensure*]
#  present, absent to use package manager or false to disable package resource
# [*server*]
#  server to send changes to
# [*username*]
#  zabbix password for the server
# [*password*]
#  zabbix password for the server
# [*http_username*]
#  http password for the server
# [*http_password*]
#  http password for the server
#
# === Issues
#
# * only really tested on some debian flavors
#
class zabbix::api (
  $ensure             = $zabbix::params::api_ensure,
  $server             = $zabbix::params::server_hostname,
  $username           = $zabbix::params::api_username,
  $password           = $zabbix::params::api_password,
  $http_username      = $zabbix::params::api_http_username,
  $http_password      = $zabbix::params::api_http_password) inherits zabbix::params {
  validate_re($ensure, [absent, present])

  file { '/etc/puppet/zabbix.yaml':
    content => template('zabbix/zabbix.yaml.erb'),
    mode    => '0500',
    owner   => 'zabbix',
    group   => 'zabbix',
    require => Package['zabbixapi']
  }

  #ensure the configuration file is enabled before we use the api
  File['/etc/puppet/zabbix.yaml'] -> Zabbix_api <| |>
  File['/etc/puppet/zabbix.yaml'] -> Zabbix_host <| |>
  File['/etc/puppet/zabbix.yaml'] -> Zabbix_host_interface <| |>
  File['/etc/puppet/zabbix.yaml'] -> Zabbix_hostgroup <| |>
  File['/etc/puppet/zabbix.yaml'] -> Zabbix_mediatype <| |>
  File['/etc/puppet/zabbix.yaml'] -> Zabbix_template <| |>
  File['/etc/puppet/zabbix.yaml'] -> Zabbix_template_application <| |>
  File['/etc/puppet/zabbix.yaml'] -> Zabbix_template_item <| |>
  File['/etc/puppet/zabbix.yaml'] -> Zabbix_trigger <| |>

  package { 'zabbixapi':
    ensure   => 'latest',
    provider => 'gem',
  }
}

