# == Class: zabbix::server::gentoo
#
class zabbix::server::gentoo ($ensure = exists) {

  package_use { 'net-analyzer/zabbix':
    ensure => $ensure,
    use    => [
      'ldap',
      'mysql',
      'server',
      'jabber',
      'snmp',
      '-sqlite'
    ]
  }
}
