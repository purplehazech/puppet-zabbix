# == Class: zabbix::agent::gentoo
#
# activate agent use flag for zabbix package
#
class zabbix::agent::gentoo (
  $ensure = present
) {

  package_use { 'net-analyzer/zabbix-agent':
    ensure => present,
    use    => ['agent'],
    target => '10_zabbix__agent'
  }

}
