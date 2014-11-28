require "puppet"

describe "zabbix_trigger" do
  let(:provider) { Puppet::Type.type(:zabbix_trigger) }
  
  it "should get defined as provider" do
  
    resource = Puppet::Type.type(:zabbix_trigger).new({
      :name => 'my rspec trigger',
    })
    expect(resource.provider.class.to_s).to eq("Puppet::Type::Zabbix_trigger::ProviderRuby")
  end
  
  it "should return false on inexistant triggers" do
    resource = Puppet::Type.type(:zabbix_trigger).new({
      :name => 'not my rspec trigger',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    expect(resource.provider().exists?).to be false
  end

  it "should return true on a newly created trigger" do

    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    template = Puppet::Type.type(:zabbix_template).new({
      :name => 'my rspec triggers template 1',
    })
    if !template.provider.exists?
      template.provider().create()
    end
    item = Puppet::Type.type(:zabbix_template_item).new({
      :name => 'my rspec triggers template item',
      :key => 'rspec.trigger.tpl.item',
      :template => 'my rspec triggers template 1'
    })
    if !item.provider.exists?
      item.provider().create()
    end
    resource = Puppet::Type.type(:zabbix_trigger).new({
      :description => 'my existing rspec trigger',
      :expression => '{my rspec triggers template 1:rspec.trigger.tpl.item.last(0)}=0'
    })
    if !resource.provider.exists?
      resource.provider.create()
    end
    
    expect(resource.provider().exists?).to be true
  end
  
  it "should create a trigger in a template, find it and delete it again" do
    template = Puppet::Type.type(:zabbix_template).new({
      :name => 'my rspec triggers template 2',
    })
    item = Puppet::Type.type(:zabbix_template_item).new({
      :name => 'my rspec triggers template item',
      :key => 'rspec.trigger.tpl.item',
      :template => 'my rspec triggers template 2'
    })
    resource = Puppet::Type.type(:zabbix_trigger).new({
      :description => 'my rspec trigger',
      :expression => '{my rspec triggers template 2:rspec.trigger.tpl.item.last(0)}=0'
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    if !template.provider.exists?
      template.provider().create()
    end
    if !item.provider.exists?
      item.provider().create()
    end
    resource.provider().create()
    expect(resource.provider().exists?).to be true
    resource.provider().destroy()
    expect(resource.provider().exists?).to be false
  end
end
