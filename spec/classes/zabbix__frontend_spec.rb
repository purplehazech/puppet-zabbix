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
      should contain_class('zabbix::params')
      should contain_class('zabbix::frontend::gentoo').with({
        :ensure  => 'present',
      })
      should contain_class('zabbix::frontend::vhost').with({
        :ensure  => 'present',
      })
      should contain_webapp_config('zabbix').with({
        :action  => 'install', 
        :vhost   => 'f.q.d.n.example.com',
        :base    => '/zabbix', 
        :app     => 'zabbix', 
        :version => '2.0.3',
      })
    }
  end
  
  context "use host parameter" do
    let(:facts) {
      {
        :operatingsystem => 'Gentoo',
        :fqdn => 'one.local'
      }
    }
    let(:params) {
      {
        :hostname => 'two.local'
      }
    }
    it {
      should contain_webapp_config('zabbix').with({
        :vhost => 'two.local'
      })
      }
  end
  
  context "it should fail with invalid ensure" do
    let(:params) {
      {
        :ensure => 'ohnoez'
      }
    }
    it {
      expect {
        contain_class('zabbix::frontend')
      }.to raise_error(Puppet::Error, /validate_re/)
    }
  end
end
