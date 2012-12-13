
require "puppet"
require "zabbixapi"

# mixin for generic zabbix api stuff
module Zabbix
  # initialy load config and setup zabbix api
  def zbx
    
    config_file = File.join(File.dirname(Puppet.settings[:config]), "zabbix.yaml")
    raise(Puppet::ParseError, "Zabbix report config file #{config_file} not readable") unless File.exist?(config_file)
    config = YAML.load_file(config_file)

    zbx = ZabbixApi.connect(
      :url => config.fetch('zabbix_url', 'http://localhost/zabbix/api_jsonrpc.php'),
      :user => config.fetch('zabbix_user','Admin'),
      :password => config.fetch('zabbix_password', 'zabbix')
    )
    return zbx
  end

end