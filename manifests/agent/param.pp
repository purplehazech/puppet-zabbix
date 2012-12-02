# == Define: zabbix::agent::param
#
define zabbix::agent::param (
  $ensure   = undef,
  $key      = undef,
  $command  = undef,
  $path     = undef,
  $index    = undef,
  $file     = undef,
  $template = undef) {
  include zabbix::params
  $ensure_real   = $ensure ? {
    undef   => $zabbix::params::agent_param_ensure,
    default => $ensure
  }
  $key_real      = $key ? {
    undef   => $name,
    default => $key
  }
  $command_real  = $command ? {
    undef   => $zabbix::params::agent_param_command,
    default => $command
  }
  $path_real     = $path ? {
    undef   => $zabbix::params::agent_include_path,
    default => $path
  }
  $index_real    = $index ? {
    undef   => $zabbix::params::agent_param_index,
    default => $index
  }
  $file_real     = $file ? {
    undef   => "${path_real}/${index_real}_${key_real}.conf",
    default => $file
  }
  $template_real = $template ? {
    undef   => $zabbix::params::agent_param_template,
    default => $template
  }

  file { $file_real:
    ensure  => $ensure_real,
    content => template($template_real)
  }
}
