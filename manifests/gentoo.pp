# == Class: zabbix::gentoo
#
# create files for portage
#
# for now you should keyword the proper version you want by hand
# since i have decided not to touch /etc/portage/package.keywords
# automatically.
#
class zabbix::gentoo {
  file { '/etc/portage/package.use/10_zabbix':
    content => 'net-analyzer/zabbix curl'
  }
}
