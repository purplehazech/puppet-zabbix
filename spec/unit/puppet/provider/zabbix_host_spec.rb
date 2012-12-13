
describe "zabbix_host" do
  let(:provider) { Puppet::Type.type(:zabbix_host) }
  
  it "should get defined as provider" do
  
    resource = Puppet::Type.type(:zabbix_host).new({
      :name => 'my.rspec.host',
    })
    resource.provider.class.to_s.should == "Puppet::Type::Zabbix_host::ProviderRuby"
  end
  
  it "should return false on inexistant hosts" do
    resource = Puppet::Type.type(:zabbix_host).new({
      :name => 'not.my.rspec.host',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    resource.provider().exists?().should be_false
  end

  it "should return true on a newly created host" do

    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"

    hostgroup = Puppet::Type.type(:zabbix_hostgroup).new({
      :name => 'rspec host group'
    })
    if !hostgroup.provider.exists?
      hostgroup.provider.create()
    end
    
    groups = [
      "rspec host group"
    ]
    interfaces = [
      {
        "type" => 1,
        "main" => 1,
        "useip" => 1,
        "ip" => "192.168.3.1",
        "dns" => "",
        "port" => "10050"
      }
    ]
    resource = Puppet::Type.type(:zabbix_host).new({
      :name => 'my.existing.rspec.host',
      :interfaces => 'inties',
      :groups => groups
    })
    if !resource.provider.exists?
      resource.provider.create()
    end
    
    resource.provider().exists?().should be_true
  end
  
  it "should create a host, find it and delete it again" do
    resource = Puppet::Type.type(:zabbix_host).new({
      :name => 'my.rspec.host',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    resource.provider().create()
    resource.provider().exists?().should be_true
    resource.provider().destroy()
    resource.provider().exists?().should be_false
  end
end