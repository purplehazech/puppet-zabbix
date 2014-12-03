Puppet::Type.type(:zabbix_host).provide(:ruby) do
  desc "zabbix_host type"
  confine :feature => :zabbixapi

  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../../../../lib/ruby/")
  require "zabbix"
  require "pp"


  def exists?
    extend Zabbix
    return (zbx.hosts.get_id(
      :host => resource[:host]
    ).is_a? Integer)
  end
  
  def create
    extend Zabbix
    groups = Array.new
    group_names = resource[:groups]
    group_names = [group_names] if ! group_names.is_a? Array
    group_names.each do |group|
      groups.push({
        :groupid => zbx.hostgroups.get_id(:name => group)
      })
    end
    zbx.query(
      :method => 'host.create',
      :params => [
        :host => resource[:host],
        :status => resource[:status],
        :interfaces => [
          {
          :type => 1,
          :main =>1,
          :useip => resource[:ip] == nil ? 0 : 1,
          :usedns => resource[:ip] == nil ? 1 : 0,
          :dns => resource[:host],
          :ip => resource[:ip] == nil ? "" : resource[:ip],
          :port => 10050,
          }
        ],
        :proxy_hostid => resource[:proxy_hostid] == nil ? 0 : resource[:proxy_hostid],
        :groups => groups,
      ]
    )
  end
  
  def destroy
    extend Zabbix
    hostid = zbx.hosts.get_id(:host => resource[:host])
    zbx.query(
      :method => 'host.delete',
      :params => [
        hostid
      ]
    )
  end
end
