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
#  present or absent for core utils
# [*agent*]
#  present or absent for agent config
# [*server*]
#  present or absent for server config
# [*frontend*]
#  present or absent for sever config
# [*api*]
#  present or absent for api usage (needed by Zabbix_* resources)
#
# === Example Usage
#
#   $zabbix::params::server_host = 'zabbix'
#   include zabbix
#
# === Todos:
# * get server ip from resource collecor
# * userparams via resource collectors
# * resource collectors
# * resource
# * res
#
class zabbix (
  $ensure   = $zabbix::params::ensure,
  $agent    = $zabbix::params::agent,
  $server   = $zabbix::params::server,
  $frontend = $zabbix::params::frontend,
  $api      = $zabbix::params::api,
  $export   = $zabbix::params::export) inherits zabbix::params {
    
    
  case $::operatingsystem {
    'Gentoo' : {
      class { 'zabbix::gentoo':
        ensure => $ensure,
        before => Class['zabbix::agent']
      }
    }
    'Debian' : {
      include zabbix::debian
      Class['zabbix::debian'] -> Class['zabbix::agent']
    }
  }
    
  class { 'zabbix::agent':
    ensure => $agent,
  }

  if ($server == present) {
    class { 'zabbix::server':
      ensure => $server,
      export => $export,
    }
    Class['zabbix::agent'] -> Class['zabbix::server']
  }
  
  if ($frontend == present) {
    class { 'zabbix::frontend':
      ensure  => $frontend,
      require => Class['zabbix::agent']
    }
    Class['zabbix::server'] -> Class['zabbix::frontend']
  }
  
  class { 'zabbix::api':
    ensure  => $api,
  }

  class { 'zabbix::reports':
    ensure  => $reports,
  }

}
