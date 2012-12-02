# == Class: zabbix
#
# Install and configure zabbix agent on a system. This class is part of
# our default setup, we install the zabbix agent on every machine and
# configure it to send info to the server on a regular base. This is
# simply a classic active zabbix agent setup.
#
# See zabbix::params for a list of supported operating systems.
#
# === Parameters
#
# [*::zabbix_server_ip*]
#   where to reach the zabbix server instance, may also be a hostname but
#   ips are recommended
#
# === Example Usage
#
#   $zabbix_server_ip = 'zabbix'
#   include zabbix
#
# === Todos:
# * implement zabbix server with autoprovisioning based on resource collectors
# * get server ip from resource collecor
# * userparams via resource collectors
# * resource collectors
# * resource
# * res
# * .
#
class zabbix ($ensure = undef) {
  include zabbix::params
  $ensure_real = $ensure ? {
    undef   => $zabbix::params::ensure,
    default => $ensure
  }

  if defined("zabbix::${::operatingsystem}") {
    class { "zabbix::${::operatingsystem}":
    }
  }

  # install agent on every machine
  include zabbix::agent

  # needed by the included libs
  package { 'zbxapi':
    ensure   => $ensure_real,
    provider => 'gem'
  }
}