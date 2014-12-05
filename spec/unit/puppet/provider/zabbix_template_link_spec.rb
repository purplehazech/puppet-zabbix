require 'puppet'

describe 'zabbix_template_link' do
  let(:provider) { Puppet::Type.type(:zabbix_template_link) }

  it 'should get defined as provider' do
    resource = Puppet::Type.type(:zabbix_template_link).new({
      :name => 'rspec template link'
    })

    expect(resource.provider.class.to_s).to eq('Puppet::Type::Zabbix_template_link::ProviderRuby')
  end

  it 'should link a host to a template' do
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"

    hostgroup = Puppet::Type.type(:zabbix_hostgroup).new({
      :name => 'rspec host group'
    })
    if !hostgroup.provider.exists?
      hostgroup.provider.create()
    end
    host = Puppet::Type.type(:zabbix_host).new({
      :name   => 'my.template.link.rspec.host',
      :groups => [ 'rspec host group' ]
    })
    if not host.provider.exists? then
      host.provider.create()
    end
    template = Puppet::Type.type(:zabbix_template).new({
      :name => 'spec template for linking'
    })
    if not template.provider.exists? then
      template.provider.create()
    end

    resource = Puppet::Type.type(:zabbix_template_link).new({
      :name     => 'rspec template link',
      :host     => 'my.template.link.rspec.host',
      :template => 'spec template for linking'
    })

    if not resource.provider.exists?
      resource.provider.create()
    end

    expect(resource.provider.exists?).to be true
  end

  it 'should link a host to a template and remove the link again' do
    Puppet.settings[:config]= "#{File.dirname(__FILE__)}/../../../../tests/etc/puppet.conf"

    hostgroup = Puppet::Type.type(:zabbix_hostgroup).new({
      :name => 'rspec host group'
    })
    if !hostgroup.provider.exists?
      hostgroup.provider.create()
    end
    host = Puppet::Type.type(:zabbix_host).new({
      :name   => 'my.template.link.rspec.host',
      :groups => [ 'rspec host group' ]
    })
    if not host.provider.exists? then
      host.provider.create()
    end
    template = Puppet::Type.type(:zabbix_template).new({
      :name => 'spec template for linking'
    })
    if not template.provider.exists? then
      template.provider.create()
    end

    resource = Puppet::Type.type(:zabbix_template_link).new({
      :name     => 'rspec template link 2',
      :host     => 'my.template.link.rspec.host',
      :template => 'spec template for linking'
    })

    resource.provider.create()
    expect(resource.provider.exists?).to be true
    resource.provider.destroy()
    expect(resource.provider.exists?).to be false
  end
end
