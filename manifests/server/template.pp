# == Define: zabbix::server::template
#
# install a template on the server
#
# === Parameters
# [*ensure*]
#   present or absent, default is present
#
define zabbix::server::template ($ensure = 'present') {
  zabbix_api { $name:
    type     => 'template',
    server   => $zabbix::params::frontend_url,
    user     => $zabbix::params::frontend_user,
    password => $zabbix::params::frontend_password
  }
}
