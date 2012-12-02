# == Class: zabbix::agent::gentoo
#
# activate agent use flag for zabbix package
#
class zabbix::agent::gentoo {
  file { '/etc/portage/package.use/10_zabbix__agent':
    content => 'net-analyzer/zabbix agent'
  }

}
 