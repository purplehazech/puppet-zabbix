node default {
  $ensure   = present
  # $ensure = absent
  $server   = 'http://192.168.1.102/zabbix'
  $user     = 'Admin'
  $password = 'zabbix'

  zabbix_api { 'Template_App_Test':
    ensure   => $ensure,
    type     => 'template',
    server   => $server,
    user     => $user,
    password => $password,
  }

  zabbix_api { 'Application_App_Test':
    ensure   => $ensure,
    type     => 'application',
    host     => 'Template_App_Test',
    require  => $ensure ? {
      absent  => Zabbix_api['test.test'],
      default => Zabbix_api['Template_App_Test']
    },
    server   => $server,
    user     => $user,
    password => $password,
  }

  zabbix_api { 'test.test':
    ensure      => $ensure,
    type        => 'item',
    host        => 'Template_App_Test',
    description => 'test item',
    application => 'Application_App_Test',
    require     => $ensure ? {
      absent  => [Zabbix_api['{Template_App_Test:test.test.last(0)}=0'], Zabbix_api['{Template_App_Test:test.test.last(0)}=1']],
      default => Zabbix_api['Application_App_Test']
    },
    server      => $server,
    user        => $user,
    password    => $password,
  }

  zabbix_api { '{Template_App_Test:test.test.last(0)}=0':
    ensure      => $ensure,
    type        => 'trigger',
    host        => 'Template_App_Test',
    description => 'test trigger',
    require     => $ensure ? {
      absent  => [],
      default => Zabbix_api['test.test']
    },
    server      => $server,
    user        => $user,
    password    => $password,
  }

  zabbix_api { '{Template_App_Test:test.test.last(0)}=1':
    ensure      => $ensure,
    type        => 'trigger',
    host        => 'Template_App_Test',
    description => 'test trigger 1',
    require     => $ensure ? {
      absent  => [],
      default => Zabbix_api['test.test']
    },
    server      => $server,
    user        => $user,
    password    => $password,
  }

}
