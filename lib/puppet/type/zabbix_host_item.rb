
Puppet::Type.newtype(:zabbix_host_item, :parent => Puppet::Type.type(:zabbix_item)) do
  desc <<-EOT
    Manage a host item in Zabbix
  EOT

  newparam(:host_type) do
    desc <<-EOT
     Type of the host.
     
     Possible values: 
     * 0 - can be both; 
     * 1 - host; 
     * 2 - template; 
    EOT
    defaultto 1
  end

  autorequire(:zabbix_host) do
    [self[:host]]
  end
end
