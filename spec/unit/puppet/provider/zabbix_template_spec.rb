
describe "zabbix_template" do
  let(:provider) { Puppet::Type.type(:zabbix_template) }
  
  it "should get defined as provider" do
  
    resource = Puppet::Type.type(:zabbix_template).new({
      :name => 'blerghli',
    })
    resource.provider.class.to_s.should == "Puppet::Type::Zabbix_template::ProviderRuby"
  end
  
  it "should return false on inexistant templates" do
    resource = Puppet::Type.type(:zabbix_template).new({
      :name => 'blerghli',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    resource.provider().exists?().should == false
  end
  
  it "should create a template, find it and delete it again" do
    resource = Puppet::Type.type(:zabbix_template).new({
      :name => 'blerghli',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    resource.provider().create()
    resource.provider().exists?().should == true
    resource.provider().destroy()
    resource.provider().exists?().should == false
  end
end