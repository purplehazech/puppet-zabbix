
Puppet::Type.newtype(:zabbix_template_item) do
  desc <<-EOT
    Manage a template item in Zabbix
  EOT

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc 'Name of the item.'
  end

  newparam(:applications) do
    desc 'Array of applications to add the item to.'
    defaultto []
  end

  newparam(:host) do
    desc 'ID of the host or template that the item belongs to.'
  end

  newparam(:template) do
    desc 'Template to contain this item in.'
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

  newparam(:interface) do
    desc 'ID of the item\'s host interface.'
    defaultto 0
  end

  newparam(:description) do
    desc <<-EOT
      Description of the item.
    EOT
  end

  newparam(:key) do
    desc 'Item key.'
  end

  newparam(:type) do
    desc <<-EOT
     Type of the item.

     Possible values:
     * 0 - Zabbix agent;
     * 1 - SNMPv1 agent;
     * 2 - Zabbix trapper;
     * 3 - simple check;
     * 4 - SNMPv2 agent;
     * 5 - Zabbix internal;
     * 6 - SNMPv3 agent;
     * 7 - Zabbix agent (active);
     * 8 - Zabbix aggregate;
     * 9 - web item;
     * 10 - external check;
     * 11 - database monitor;
     * 12 - IPMI agent;
     * 13 - SSH agent;
     * 14 - TELNET agent;
     * 15 - calculated;
     * 16 - JMX agent.
    EOT
    defaultto 0
    # @todo support nice strings like from the zabbix apidocs here
  end

  newparam(:value_type) do
    desc <<-EOT
      Type of information of the item.

      Possible values:
      * 0 - numeric float;
      * 1 - character;
      * 2 - log;
      * 3 - numeric unsigned;
      * 4 - text.
    EOT
    defaultto 0
  end

  autorequire(:zabbix_template) do
    [self[:host]]
  end
end
