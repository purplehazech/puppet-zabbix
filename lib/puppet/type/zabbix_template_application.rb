
Puppet::Type.newtype(:zabbix_template_application) do
  desc <<-EOT
    Manage a template application in Zabbix
  EOT

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:host) do
    desc 'Host'
  end

  newparam(:host_type) do
    desc <<-EOT
     Type of the host.
     
     Possible values: 
     * 0 - can be both; 
     * 1 - host; 
     * 2 - template; 
    EOT
    defaultto 2
  end

  autorequire(:zabbix_template) do
    [self[:host]]
  end  
end
