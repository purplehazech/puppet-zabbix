# == Class: zabbix::frontend::gentoo
#
# Gentoo specific use flags for frontend
#
class zabbix::frontend::gentoo ($ensure = present) {
  file { '/etc/portage/package.use/10_zabbix__frontend':
    ensure  => $ensure,
    content => 'net-analyzer/zabbix ldap mysql frontend snmp'
  } -> file { '/etc/portage/package.use/10_zabbix__frontend_dev_lang_php':
    ensure  => $ensure,
    content => 'dev-lang/php truetype gd bcmath sockets sysvipc'
  } -> file { '/etc/portage/package.use/10_zabbix__frontend_dev_lang_php_xml':
    ensure  => $ensure,
    content => 'dev-lang/php xmlwriter xmlreader'
  } -> file { '/etc/portage/package.use/10_zabbix__frontend_php_apache':
    ensure  => $ensure,
    content => 'dev-lang/php apache2'
  } -> file { '/etc/portage/package.use/10_zabbix__frontend_dev_lang_php_mysql':
    ensure  => $ensure,
    content => 'dev-lang/php mysql'
  } -> file { '/etc/portage/package.use/10_zabbix__frontend_dev_lang_php_ldap':
    ensure  => $ensure,
    content => 'dev-lang/php ldap'
  } -> file { '/etc/portage/package.use/10_gd-zabbix__frontend_media_libs_gd':
    ensure  => $ensure,
    content => 'media-libs/gd png'
  }
}
