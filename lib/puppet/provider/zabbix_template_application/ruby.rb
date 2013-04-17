$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../../../../lib/ruby/")
require "zabbix"
require "pp"

Puppet::Type.type(:zabbix_template_application).provide(:ruby) do
  desc "zabbix_template type"

  def exists?
    extend Zabbix
    return (zbx.applications.get_id(
      :name => resource[:name]
    ).is_a? Integer)
  end
  
  def create
    extend Zabbix
    zbx.applications.create(
      :name => resource[:name], 
      :hostid => zbx.templates.get_id(
        :host => resource[:host] 
      )
    )
  end
  
  def destroy
    extend Zabbix
    zbx.applications.delete( zbx.applications.get_id( :name => resource[:name] ) )
  end
end
