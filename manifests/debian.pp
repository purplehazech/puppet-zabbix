# == Class: zabbix::debian
#
# create files for aptitude
#
# This adds a repository for the current zabbix version
#
class zabbix::debian () inherits zabbix::params {
  apt::source { 'zabbixzone':
    location   => 'http://repo.zabbixzone.com/debian',
    repos      => 'main contrib non-free',
    release    => 'squeeze',
    key        => '25FFD7E7',
    key_server => 'keys.gnupg.net'
  }
}
