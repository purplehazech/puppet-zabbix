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

  if (lookup('use_api', 'Boolean')) {
    package { 'zabbixapi':
      ensure   => present,
      provider => 'gem',
    }
  }

  package_use { 'net-analyzer/zabbix':
    ensure  => present,
    use     => concat(
      concat(
        $default_use_flags,
        $agent_use_flags
      ),
      concat(
        $server_use_flags,
        $frontend_use_flags
      )
    ),
  }

  if ($frontend_defined) {
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
    }

    package_use { 'media-libs/gd':
      ensure => true,
      use    => [
        'png',
      ],
    }

    $webapp_host = lookup('frontend_hostname', 'String')
    $webapp_base = lookup('frontend_base', 'String')
    webapp { "${webapp_host}::${webapp_base}":
      appname    => 'zabbix',
      appversion => lookup('version'),
      server     => 'apache',
      user       => 'apache',
      group      => 'apache',
      secure     => true,
      before     => File[lookup('frontend_conf_file', 'String')],
      onlyif     => $frontend_defined
    }
  }

}
