# == Class: zabbix::server::gentoo
#
class zabbix::server::gentoo ($ensure = exists) {
  file { '/etc/portage/package.use/10_zabbix__server':
    ensure  => $ensure,
    content => 'net-analyzer/zabbix  ldap mysql server jabber snmp -sqlite'
  }
}
