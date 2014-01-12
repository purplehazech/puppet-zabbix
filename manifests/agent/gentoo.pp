# == Class: zabbix::agent::gentoo
#
# activate agent use flag for zabbix package
#
class zabbix::agent::gentoo (
  $ensure = present
) {

  package_use { 'net-analyzer/zabbix-agent':
    ensure => present,
    use    => ['agent'],
    target => '10_zabbix__agent'
  } ->
  # this gem is a dependency of this module
  # @todo librarian-puppet should pull this!
  package { 'zabbixapi':
    ensure   => present,
    provider => 'gem',
  }

}
