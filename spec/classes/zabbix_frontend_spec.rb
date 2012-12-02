require 'spec_helper'

describe 'zabbix::frontend' do
  
  context "on gentoo" do
    let(:facts) { 
      {
        :fqdn            => 'f.q.d.n.example.com',
        :operatingsystem => 'Gentoo',
      }
    }
    let(:params) {
      {
        :ensure  => 'present',
        :version => '2.0.3',
      }
    }
    it {
      should contain_class('zabbix::frontend::gentoo').with({
        :ensure  => 'present',
      })
      should contain_webapp_config('zabbix').with({
        :action  => 'install', 
        :vhost   => 'f.q.d.n.example.com',
        :base    => '/zabbix', 
        :app     => 'zabbix', 
        :version => '2.0.3',
      })
      should contains_class('zabbix::frontend::vhost').with({
        :ensure  => 'present',
      })
    }
  end
end
