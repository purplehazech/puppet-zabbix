# == Class: zabbix::zabbix
#
# virtuals and userparms for the api
#
# most class should have something like this, in most cases it should be
# called modulename::zabbix
#
# === Parameters
#
# [*ensure*]
#   absent or present, use decide if we should export anything
#
class zabbix::externals ($ensure = undef) {
  include zabbix::params
}
