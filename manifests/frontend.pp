class zabbix::frontend {
  # in /etc/php/apache2-php5.4/php.ini do
  #   date.timezone = Europe/Zurich
  #   post_max_size = 32M
  #   max_execution_time = 600
  #   max_input_time = 600
  # setup /usr/share/webapps/zabbix/2.0.3/htdocs/include/db.inc.php
  #   $DB_TYPE='SQLITE3';
  #   $zabbix_database_* vars
  # webapp-config -I -h localhost -d zabbix zabbix 2.0.3
}
