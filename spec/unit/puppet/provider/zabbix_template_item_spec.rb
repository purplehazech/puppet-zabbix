
describe "zabbix_template_item", :broken => true do
  let(:provider) { Puppet::Type.type(:zabbix_template_item) }
  
  it "should get defined as provider" do
  
    resource = Puppet::Type.type(:zabbix_template_item).new({
      :name => 'my rspec template item',
    })
    resource.provider.class.to_s.should == "Puppet::Type::Zabbix_template_item::ProviderRuby"
  end
  
  
  it "should return false on inexistant template apps" do
    resource = Puppet::Type.type(:zabbix_template_item).new({
      :name => 'not my rspec template item',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    false == resource.provider().exists?()
  end
  
  it "should create a template item, find it and delete it again" do
    template = Puppet::Type.type(:zabbix_template).new({
      :name => 'my rspec items template',
    })
    resource = Puppet::Type.type(:zabbix_template_item).new({
      :name => 'my rspec item',
      :host => 'my rspec items template'
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