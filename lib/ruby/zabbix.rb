require "puppet"

# mixin for generic zabbix api stuff
module Zabbix
  # initialy load config and setup zabbix api
  def zbx
    return nil if ! Puppet.features.zabbixapi?
    require "zabbixapi" 


    config_file = File.join(File.dirname(Puppet.settings[:config]), "zabbix.api.yaml")
    raise(Puppet::ParseError, "Zabbix report config file #{config_file} not readable") unless File.exist?(config_file)
    config = YAML.load_file(config_file)

    zbx = ZabbixApi.connect(
      :url => config.fetch('zabbix_url', 'http://localhost/zabbix/api_jsonrpc.php'),
      :user => config.fetch('zabbix_user','Admin'),
      :password => config.fetch('zabbix_password', 'zabbix'),
      :http_user => config.fetch('zabbix_http_user', nil),
      :http_password => config.fetch('zabbix_http_password', nil),
      :debug => config.fetch('zabbix_debug', false)
    )
    return zbx
  end

  def get_template_or_host_id(hostname)
      result = zbx.query(
          :method => "host.get",
          :params => {
              :templated_hosts => 1,
              :filter => {
                  :host => hostname  
              },
              :output => "extend"
          }
      )
      id = nil
      result.each { |item| id = item["hostid"].to_i if item["host"] == hostname }
      id
  end
end
