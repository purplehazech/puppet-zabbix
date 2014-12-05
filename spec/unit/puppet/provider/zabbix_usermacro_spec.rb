require 'puppet'

describe 'zabbix_usermacro' do
  let(:provider) { Puppet::Type.type(:zabbix_usermacro) }

  it 'should get defined as provider' do
    resource = Puppet::Type.type(:zabbix_usermacro).new({
      :name   => 'rspec usermacro',
      :global => true
    })
    expect(resource.provider.class.to_s).to eq("Puppet::Type::Zabbix_usermacro::ProviderRuby")
  end

  it 'should create and destroy a global usermacro' do
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"

    resource = Puppet::Type.type(:zabbix_usermacro).new({
      :name   => 'rspec global usermacro',
      :global => true,
      :macro  => '{$RSPEC_TEST_GLOBAL_USERMACRO}',
      :value  => 'test'
    })

    resource.provider.create()
    expect(resource.provider.exists?).to be true 
    resource.provider.destroy()
    expect(resource.provider.exists?).to be false
  end

  it 'should create and destroy a host usermacro' do
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"

    hostgroup = Puppet::Type.type(:zabbix_hostgroup).new({
      :name => 'rspec host group'
    })
    if !hostgroup.provider.exists?
      hostgroup.provider.create()
    end
 
    host = Puppet::Type.type(:zabbix_host).new({
      :name   => 'rspec.usermacro.test.host',
      :groups => [ 'rspec host group' ] 
    });
    if not host.provider.exists? then
      host.provider.create()
    end

    resource = Puppet::Type.type(:zabbix_usermacro).new({
      :name   => 'rspec usermacro',
      :global => false,
      :host   => 'rspec.usermacro.test.host',
      :macro  => '{$RSPEC_TEST_USERMACRO}',
      :value  => 'test'
    })

    resource.provider.create()
    expect(resource.provider.exists?).to be true 
    resource.provider.destroy()
    expect(resource.provider.exists?).to be false
  end
end
