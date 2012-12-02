# == Class: zabbix::server::gentoo
#
class zabbix::server::gentoo {
  file { '/etc/portage/package.use/10_zabbix__server':
    content => 'net-analyzer/zabbix  ldap mysql server jabber snmp -sqlite';
  }

}
