# == Class: zabbix::debian
#
# create files for aptitude
#
# This adds a repository for the current zabbix version
#
class zabbix::debian () {
  $diststring=downcase($lsbdistid)
  apt::source { 'zabbix':
    location   => "http://repo.zabbix.com/zabbix/2.4/$diststring",
    repos      => 'main contrib non-free',
    release    => $lsbdistcodename,
    key        => '79EA5ED4',
	  key_source => 'http://repo.zabbix.com/zabbix-official-repo.key'
  }
  
  apt::source { 'zabbixzone':
    ensure => absent
  }
}
