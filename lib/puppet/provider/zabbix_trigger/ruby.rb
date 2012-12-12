$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../../../lib/ruby/")
require "zabbix"

Puppet::Type.type(:zabbix_trigger).provide(:ruby) do
  desc "zabbix trigger provider"

  def exists?
    extend Zabbix
    zbx.triggers.get_id(
      :expression => resource[:expression]
    ).is_a? Integer
  end
  
  def create
    extend Zabbix
  end
  
  def destroy
    extend Zabbix
  end
end