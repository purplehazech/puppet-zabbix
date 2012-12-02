class zabbix::gentoo {
  file { '/etc/portage/package.use/10_zabbix':
    content => 'net-analyzer/zabbix  agent curl';
  }
}
