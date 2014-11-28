require "puppet"

describe "zabbix_host" do
  let(:provider) { Puppet::Type.type(:zabbix_host) }
  
  it "should get defined as provider" do
  
    resource = Puppet::Type.type(:zabbix_host).new({
      :name => 'my.rspec.host',
    })
    expect(resource.provider.class.to_s).to eq("Puppet::Type::Zabbix_host::ProviderRuby")
  end
  
  it "should return false on inexistant hosts" do
    resource = Puppet::Type.type(:zabbix_host).new({
      :name => 'not.my.rspec.host',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"

    expect(resource.provider().exists?()).to be false
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
    resource = Puppet::Type.type(:zabbix_host).new({
      :name => 'my.existing.rspec.host',
      :groups => groups
    })
    if !resource.provider.exists?
      resource.provider.create()
    end
    
    expect(resource.provider().exists?()).to be true
  end
  
  it "should create a host, find it and delete it again" do

    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"

    hostgroup = Puppet::Type.type(:zabbix_hostgroup).new({
      :name => 'rspec host group 2'
    })
    if !hostgroup.provider.exists?
      hostgroup.provider.create()
    end
    resource = Puppet::Type.type(:zabbix_host).new({
      :name => 'my.rspec.host',
      :groups => [
        "rspec host group 2"
      ]
    })
    resource.provider().create()
    expect(resource.provider().exists?()).to be true
    resource.provider().destroy()
    expect(resource.provider().exists?()).to be false
  end
end
