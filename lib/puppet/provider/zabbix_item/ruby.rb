Puppet::Type.type(:zabbix_item).provide(:ruby) do
  desc "zabbix item provider"
  confine :feature => :zabbixapi
  
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../../../../lib/ruby/")
  require "zabbix"

  def exists?
    extend Zabbix
     host_id = zbx.hosts.get({:name => resource[:host]})[0]['hostid']
     existing = zbx.query(
      :method => "item.get",
      :params => {
        :filter => {
          :name => resource[:name],
          :key_ => resource[:key],
          :hostid => [host_id]
        },
        :output => "extend"
      }
    ).length > 0
    return(existing)
  end
  
  def create
    extend Zabbix
    if not resource[:template].nil? then
      # grab host_id for template to handle tabbix_template_item case
      # @todo i should refactor this so template_item and item are not mixed as much
      host_id = zbx.templates.get_id({:host => resource[:template]})
    else
      host_id = zbx.hosts.get({:name => resource[:host]})[0]['hostid'] unless resource[:host].nil?
    end
    
    apps_real = Array.new
    resource[:applications]=[resource[:applications]] if !(resource[:applications].is_a? Array)
    resource[:applications].each do |app|
      apps_real.push(
        zbx.applications.get_id( :name => app, :hostid => host_id )
      )
    end
    
    interfaces = zbx.query(
      :method => "hostinterface.get",
      :params => {
        :hostids => [host_id],
        :output => "extend"
      }
    )
    interface_id = nil 
    interface=resource[:interface]
    interface=interface.to_i if (interface.is_a? String) && /^[-+]?\d+$/ === interface
    if (interface.is_a? Integer) && resource[:interface] != 0
      #the user specified a interface
      interface_id = interface
    else
      interfaces.each { |item| interface_id = item["interfaceid"] if item["ip"] == interface}
    end

    #as default we use the first interface defined
    #interface_id = interfaces[0]["interfaceid"].to_i if interface_id.nil?

    # @todo reactivate commented fields when i figure out why they fail
    zbx.items.create(
      :applications => apps_real,
      #:delay => resource[:delay], #60
      :hostid => host_id,
      :interfaceid => interface_id,
      :key_ => resource[:key],
      :name => resource[:name],
      :type => resource[:type],
      #:username => resource[:username],
      :value_type => resource[:value_type],
      #:authtype => resource[:authtype],
      #:data_type => resource[:data_type],
      #:delay_flex => resource[:delay_flex],
      #:delta => resource[:delta],
      :description => resource[:description]
    )
  end
  
  def destroy
    extend Zabbix
    zbx.items.delete(
      zbx.items.get_id(
        :name => resource[:name],
        :key_ => resource[:key],
        :hostid => [get_id(resource[:host], resource[:host_type])]
      )
    )
  end
end
