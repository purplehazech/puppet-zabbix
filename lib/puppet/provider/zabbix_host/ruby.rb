$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../../../lib/ruby/")
require "zabbix"
require "pp"

Puppet::Type.type(:zabbix_host).provide(:ruby) do
  desc "zabbix_host type"

  def exists?
    extend Zabbix
    return (zbx.hosts.get_id(
      :host => resource[:host]
    ).is_a? Integer)
  end
  
  def create
    extend Zabbix
    require 'pp'
    pp resource[:interfaces], resource[:groups]
    zbx.hosts.create(
      :host => resource[:host],
      :ipmi_authtype => resource[:ipmi_authtype],
      :ipmi_password => resource[:ipmi_password],
      :ipmi_privilege => resource[:ipmi_privilege],
      :ipmi_username => resource[:ipmi_username],
      :hostname => resource[:hostname],
      :proxy_hostid => resource[:proxy_hostid],
      :status => resource[:status],
      :groups => resource[:groups],
      :interfaces => resource[:interfaces]
    )
  end
  
  def destroy
#    extend Zabbix
#    zbx.applications.delete( zbx.applications.get_id( :name => resource[:name] ) )
  end
end