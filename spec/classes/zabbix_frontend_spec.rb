require 'spec_helper'

describe 'zabbix::frontend' do
  
  context "on gentoo" do
    let(:facts) { 
      {
        :operatingsystem => 'Gentoo',
        :fqdn => 'f.q.d.n.example.com'
      }
    }
    let(:params) {
      {
        :ensure  => 'present',
        :version => '2.0.3'
      }
    }
    it {
      should contain_class('zabbix::frontend::gentoo').with({
        :ensure => 'present'
      })
      should contain_webapp__config('zabbix').with({
        :action => 'install', 
        :vhost => 'f.q.d.n.example.com',
        :base => '/zabbix', 
        :app => 'zabbix', 
        :version => '2.0.3'
      })
    }
  end
end