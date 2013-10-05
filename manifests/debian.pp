# == Class: zabbix::debian
#
# create files for aptitude
#
# This adds a repository for the current zabbix version
#
class zabbix::debian () {
  apt::source { 'zabbix':
    location   => "http//repo.zabbix.com/zabbix/2.0/$lsbdistid",
    repos      => 'main contrib non-free',
    release    => $lsbdistcodename,
	key        => '79EA5ED4',
	key_server => 'keys.gnupg.net'
  }
  
  apt::source { 'zabbixzone':
    ensure => absent
  }
}
