
Puppet::Type.newtype(:zabbix_template_application) do
  desc <<-EOT
    Manage a template application in Zabbix
  EOT

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc 'Application name.'
  end
  
  newparam(:host) do
    desc 'Host'
  end
  
end