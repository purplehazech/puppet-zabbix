# == Class: zabbix::zabbix
#
# virtuals and userparms for the api
#
# most class should have something like this, in most cases it should be
# called modulename::zabbix. This is also why the user parameters are in
# here. It is expected that other modules either implement similar patterns
# to interface with this, they might even inherit this class.
#
# === Parameters
#
# [*ensure*]
#   absent or present
# [*api*]
#   enable exports based api calls, default false
# [*params*]
#   enable uerparameters, default true
#
class zabbix::externals ($ensure = undef, $api = undef) {
  include zabbix::params
  $ensure_real = $ensure ? {
    undef   => $zabbix::params::api,
    default => $api
  }
  $api_real    = $api ? {
    undef   => $zabbix::params::api_ensure,
    default => $api
  } }

