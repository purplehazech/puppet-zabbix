require "puppet"

describe "zabbix_hostgroup" do
  let(:provider) { Puppet::Type.type(:zabbix_hostgroup) }
  
  it "expect get defined as provider" do
    resource = Puppet::Type.type(:zabbix_hostgroup).new({
      :name => 'inexistant rspec hostgroup',
    })
    expect(resource.provider.class.to_s).to eq("Puppet::Type::Zabbix_hostgroup::ProviderRuby")
  end
  
  it "expect return false on inexistant hostgroup" do
    resource = Puppet::Type.type(:zabbix_hostgroup).new({
      :name => 'inexistant rspec hostgroup',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    expect(resource.provider().exists?()).to be false
  end
  
  it "expect return true on existing hostgroup" do
    resource = Puppet::Type.type(:zabbix_hostgroup).new({
      :name => 'existant rspec hostgroup',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    if !resource.provider().exists?()
      resource.provider().create()
    end
    expect(resource.provider().exists?()).to be true
  end
  
  it "expect create a hostgroup, find it and delete it again" do
    resource = Puppet::Type.type(:zabbix_hostgroup).new({
      :name => 'rspec zabbix_hostgroup',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    resource.provider().create()
    expect(resource.provider().exists?()).to be true
    resource.provider().destroy()
    expect(resource.provider().exists?()).to be false
  end
end
