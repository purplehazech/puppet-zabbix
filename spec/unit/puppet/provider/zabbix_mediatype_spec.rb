require "puppet"

describe "zabbix_mediatype" do
  let(:provider) { Puppet::Type.type(:zabbix_mediatype) }
  
  it "expect get defined as provider" do
  
    resource = Puppet::Type.type(:zabbix_mediatype).new({
      :name => 'my rspec mediatype',
    })
    expect(resource.provider.class.to_s).to eq("Puppet::Type::Zabbix_mediatype::ProviderRuby")
  end
  
  it "expect return false on inexistant mediatypes" do
    resource = Puppet::Type.type(:zabbix_mediatype).new({
      :description => 'not my rspec mediatype',
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    expect(resource.provider().exists?()).to be false
  end
  
  it "expect create a mediatype, find it and delete it again" do
    resource = Puppet::Type.type(:zabbix_mediatype).new({
      :description => 'my rspec mediatype'
    })
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"
    resource.provider().create()
    expect(resource.provider().exists?()).to be true
    resource.provider().destroy()
    expect(resource.provider().exists?()).to be false
  end
end
