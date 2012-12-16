
describe "zabbix_mediatype" do
  let(:provider) { Puppet::Type.type(:zabbix_mediatype) }
  
  it "should get defined as provider" do
  
    resource = Puppet::Type.type(:zabbix_mediatype).new({
      :name => 'my rspec mediatype',
    })
    resource.provider.class.to_s.should == "Puppet::Type::Zabbix_mediatype::ProviderRuby"
  end
end