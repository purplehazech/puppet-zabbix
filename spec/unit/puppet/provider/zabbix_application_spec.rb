
describe "zabbix_template_application" do
  let(:provider) { Puppet::Type.type(:zabbix_template_application) }
  
  it "should get defined as provider" do
  
    resource = Puppet::Type.type(:zabbix_template_application).new({
      :name => 'my rspec app',
    })
    resource.provider.class.to_s.should == "Puppet::Type::Zabbix_template_application::ProviderRuby"
  end
  
  
  it "should return false on inexistant template apps" do
    resource = Puppet::Type.type(:zabbix_template_application).new({
      :name => 'not my rspec app',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    false == resource.provider().exists?()
  end
  
  it "should create a template app, find it and delete it again" do
    template = Puppet::Type.type(:zabbix_template).new({
      :name => 'my rspec apps template',
    })
    resource = Puppet::Type.type(:zabbix_template_application).new({
      :name => 'my rspec app',
      :host => 'my rspec apps template'
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    if !template.provider.exists?()
      template.provider().create()
    end
    resource.provider().create()
    true === resource.provider().exists?()
    resource.provider().destroy()
    false === resource.provider().exists?()
  end
end