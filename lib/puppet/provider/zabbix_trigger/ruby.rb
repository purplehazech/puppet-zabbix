
Puppet::Type.type(:zabbix_trigger).provide(:ruby) do
  desc "zabbix trigger provider"
  confine :feature => :zabbixapi

  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../../../../lib/ruby/")
  require "zabbix"
  require 'pp'

  def exists?
    extend Zabbix
    zbx.client.api_request(
      :method => "trigger.exists",
      :params => {
        :expression => resource[:expression],
      })
  end
  
  def create
    extend Zabbix
    dependencies = resource[:dependencies].collect{ |triggerid| {"triggerid" => triggerid}}
    zbx.triggers.create(
      :description => resource[:description],
      :expression => resource[:expression],
      :comments => resource[:comments],
      :priority => resource[:priority],
      :status => resource[:status],
      :type => resource[:type],
      :url => resource[:url],
      :dependencies => dependencies
    )
  end
  
  def destroy
    extend Zabbix
    #When destroying we have to find the trigger by description and expression and then destroy by id
    result = zbx.client.api_request(
      :method => "trigger.get",
      :params => {
        :filter => {:description => resource[:description]},
        :output => "extend",
        :expandExpression => "data"
      }
    )
    result.each { |trigger| 
      zbx.triggers.delete(trigger["triggerid"])
    }
  end
end
