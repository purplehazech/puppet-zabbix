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
# [*ensure*]
#   present or absent for core utils
# [*agent*]
#   present or absent for agent config
# [*server*]
#   present or absent for server config
# [*frontend*]
#   present or absent for sever config
# [*api*]
#   present or absent for api usage (needed by Zabbix_api resources)
#
# === Example Usage
#
#   $zabbix::params::server_host = 'zabbix'
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
class zabbix (
  $ensure   = undef,
  $agent    = undef,
  $server   = undef,
  $frontend = undef,
  $api      = undef,
  $export   = undef) {
  include zabbix::params
  $ensure_real   = $ensure ? {
    undef   => $zabbix::params::ensure,
    default => $ensure
  }
  $agent_real    = $agent ? {
    undef   => $zabbix::params::agent,
    default => $agent
  }
  $server_real   = $server ? {
    undef   => $zabbix::params::server,
    default => $server
  }
  $frontend_real = $frontend ? {
    undef   => $zabbix::params::frontend,
    default => $frontend
  }
  $api_real      = $api ? {
    undef   => $zabbix::params::api,
    default => $api
  }
  $export_real   = $export ? {
    undef   => $zabbix::params::export,
    default => $export
  }

  if $::operatingsystem == 'Gentoo' {
    class { 'zabbix::gentoo':
      ensure => $ensure_real,
      before => Class['zabbix::agent']
    }
  }

  class { 'zabbix::agent':
    ensure => $agent_real
  }

  package { 'zbxapi':
    ensure   => $api_real,
    provider => 'gem'
  }

  class { 'zabbix::server':
    ensure  => $server_real,
    export  => $export_real,
    require => [Class['zabbix::agent'], Package['zbxapi']]
  }

  class { 'zabbix::frontend':
    ensure  => $frontend_real,
    require => Class['zabbix::agent']
  }

}
