# == Class: zabbix::bundle
#
# installs a zabbixized puppet module on both zabbix server and client
#
# Must only be included on the client.
#
# === Parameters
# [*ensure*]
#   present or absent, present is default
# [*items*]
#   hash of items to add to bundle
#
# === Example Usage
#
class zabbix::bundle (
  $ensure = 'present',
  $items  = {
  }
) {
  $ensure_real = $ensure

  @@zabbix::server::template { $name:
    ensure => $ensure_real
  }

  zabbix::agent::params { $name:
    ensure => $ensure_real,
    params => $items
  }

}
