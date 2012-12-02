# == Class: zabbix::frontend::gentoo
#
# Gentoo specific use flags for frontend
#
class zabbix::frontend::gentoo ($ensure) {
  file { '/etc/portage/package.use/10_zabbix__frontend':
    content => 'net-analyzer/zabbix ldap mysql frontend snmp'
  } -> file { '/etc/portage/package.use/10_zabbix__frontend_dev_lang_php':
    content => 'dev-lang/php truetype gd bcmath sockets sysvipc xmlwriter xmlreader'
  } -> file { '/etc/portage/package.use/10_gd-zabbix__frontend_media_libs_gd':
    content => 'media-libs/gd png'
  }
}
