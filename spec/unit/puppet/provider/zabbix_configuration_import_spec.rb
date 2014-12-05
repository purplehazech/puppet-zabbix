require 'puppet'

describe 'zabbix_configuration_import' do
  let(:provider) { Puppet::Type.type(:zabbix_configuration_import) }

  it "should get defined as provider" do
    resource = Puppet::Type.type(:zabbix_configuration_import).new({
      :name => 'rpec xml import'
    })

    expect(resource.provider.class.to_s).to eq('Puppet::Type::Zabbix_configuration_import::ProviderRuby')
  end

  # @todo add heaps more tests to test importing of all aspects that could be in an xml file
  # an example to be used during testing might be gleaned from hairmare/zabbix-iceast
end
