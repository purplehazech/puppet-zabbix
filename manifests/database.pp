# == Class: zabbix::database
#
# initialize database and user for zabbix
#
class zabbix::database (
  $name = 'zabbix',
  $host = 'localhost',
  $user = 'root',
  $password = ''
) {
  
  database { $name:
    ensure  => present,
    charset => 'utf8',
  }
  
  database_user { "${user}@${host}":
    password_hash => mysql_password($password)
  }
}