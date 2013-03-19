# == Class: zabbix::debian
#
# create files for aptitude
#
# This adds a repository for the current puppet version
#
class zabbix::debian () {
  if $::lsbdistcodename == 'squeeze' {
    apt::source { 'zabbixzone':
      location   => 'http://repo.zabbixzone.com/debian',
	  repos      => 'main',
	  key        => '8FF57A0425FFD7E7',
	  key_server => 'keys.gnupg.net',
      
	}
  }
}
