# == Define: zabbix::agent::param
#
# Create a userparameter on a zabbix agent. This works in tandem with
# zabbix::server::item to monitor resources.
#
# This is usually used to create an additional config file per UserParameter
# needed on the agent node.
#
# === Parameters
# [*ensure*]
#   present or absent
# [*key*]
#   unique key for zabbix
# [*command*]
#   command to execute as UserParamter
# [*path*]
#   path to use for zabbix conf Include dir, default is
#   '/etc/zabbix/zabbix_agentd.d'
# [*index*]
#   index number to prefix to UserParameters conf file, default is '10'
# [*file*]
#   full path to file puppet should manage
# [*template*]
#   template to use for UserParameter conf file contents
#
# === Example Usage
#
#   zabbix::agent::param { 'zabbix.key.test':
#     ensure => 'present',
#     command => 'echo "Hello World!"'
#   }
#
# === TODO
#
# * rewrite to $zabbix::params
#
define zabbix::agent::param (
  $ensure   = hiera('agent_param_ensure', present),
  $key      = hiera('agent_param_key', undef),
  $command  = hiera('agent_param_command', undef),
  $path     = hiera('agent_include_path', '/etc/zabbix/zabbix_agentd.d/'),
  $index    = hiera('agent_param_index', 10),
  $file     = hiera('agent_param_file', undef),
  $template = hiera(
    'agent_param_template',
    'zabbix/zabbix_agent_userparam.conf.erb'
  )) {
  $file_real = $file ? {
    undef   => "${path}${index}_${key}.conf",
    default => $file
  }

  file { $file_real:
    ensure  => $ensure,
    content => template($template)
  }
}
