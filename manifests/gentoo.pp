# == Class: zabbix::gentoo
#
# create files for portage
#
# for now you should keyword the proper version you want by hand
# since i have decided not to touch /etc/portage/package.keywords
# automatically.
#
class zabbix::gentoo {

  $default_use_flags = [
    'curl'
  ]

  $server_defined = defined(Class[zabbix::server])
  $server_use_flags = $server_defined ? {
    true    => [
      'ldap',
      'mysql',
      'server',
      'jabber',
      'snmp',
      '-sqlite',
    ],
    default => [],
  }

  $agent_defined = defined(Class[zabbix::agent])
  $agent_use_flags = $agent_defined ? {
    true    => [
      'agent'
    ],
    default => [],
  }

  $frontend_defined = defined(Class[zabbix::frontend])
  $frontend_use_flags = $frontend_defined ? {
    true => [
      'ldap',
      'mysql',
      'frontend',
      'snmp',
    ],
    default => [],
  }

  package { 'zabbixapi':
    ensure   => present,
    provider => 'gem',
    onlyif   => lookup('use_api', 'Boolean'),
  }

  package_use { 'net-analyzer/zabbix':
    ensure  => true,
    use     => concat(
      $default_use_flags,
      $agent_use_flags,
      $server_use_flags,
      $frontend_use_flags
    ),
  }

  package_use { 'dev-lang/php':
    ensure => true,
    use    => [
      'truetype',
      'gd',
      'bcmath',
      'sockets',
      'sysvipc',
      'xmlwriter',
      'xmlreader',
      'apache2',
      'mysql',
      'ldap',
    ],
    onlyif => $frontend_defined
  }

  package_use { 'media-libs/gd':
    ensure => true,
    use    => [
      'png',
    ],
    onlyif => $frontend_defined
  }

  # Gentoo uses webapp-config
  $webapp_action = lookup('frontend_ensure', 'Boolean') ? {
    present => 'install',
    absent  => 'remove',
    default => noop
  }

  webapp_config { 'zabbix':
    action  => $webapp_action,
    vhost   => lookup('frontend_hostname', 'String'),
    version => lookup('version'),
    app     => 'zabbix',
    base    => lookup('frontend_base', 'String'),
    depends => [],
    before  => File[lookup('frontend_conf_file', 'String')],
    onlyif  => $frontend_defined
  }

}
