# == Class: zabbix::reports
#
# Install and configure the puppet reports function for zabbix
#
# === Parameters
# [*ensure*]
#  present, absent to use package manager or false to disable package resource
# [*host*]
#  hostname of zabbix server
# [*port*]
#  port of zabbix server
# [*sender*]
#  path of the zabbix sender binary
# === Issues
#
# * only really tested on some debian flavors 
#
class zabbix::reports (
  $ensure             = $zabbix::params::reports_ensure,
  $host                = $zabbix::params::reports_host,
  $port           = $zabbix::params::reports_port,
  $sender          = $zabbix::params::reports_sender) inherits zabbix::params {
  validate_re($ensure, [absent, present])

  file { "/etc/puppet/zabbix.yaml":
    content => template("zabbix/zabbix.yaml.erb"),
    mode   => '0500',
    owner  => 'zabbix',
    group  => 'zabbix',
    require => Package['zabbix-sender']
  }

  package { 'zabbix-sender':
    ensure   => 'latest',
  }
}

