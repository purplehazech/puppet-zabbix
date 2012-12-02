require 'spec_helper'

describe 'zabbix::agent::param' do
  context "normal call" do
    let(:title) { 'foo.bar.baz' }
    
    let(:facts) { 
      {
        :operatingsystem => 'Gentoo'
      }
    }
    
    let(:params) {
      {
        :key => 'foo.bar.baz'
      }
    }
    it {
      should contain_class('zabbix::params')
      should contain_file('/etc/zabbix/zabbix_agentd.d/10_foo.bar.baz.conf').with({
        :ensure => 'present'
      })
    }
  end
end