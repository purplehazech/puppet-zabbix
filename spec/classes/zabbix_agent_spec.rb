require 'spec_helper'

describe 'zabbix::agent' do
  
  context "on debian" do
    let(:facts) { 
      {
        :operatingsystem => 'Debian'
      }
    }
    it {
      should contain_package('zabbix-agent').with({:ensure => 'present'})
      should contain_file('/etc/zabbix/zabbix_agent.conf')
      should contain_service('zabbix-agent').with({
        :ensure => 'running',
        :enable => 'true'
      })
    }
  end
  context "on gentoo" do
    let(:facts) { 
      {
        :operatingsystem => 'Gentoo'
      }
    }
    it {
      should contain_package('zabbix').with({:ensure => 'present'})
      should contain_file('/etc/zabbix/zabbix_agentd.conf')
      should contain_service('zabbix-agentd').with({
        :ensure => 'running',
        :enable => 'true'
      })
    }
  end
  
  context "on windows" do
    let(:facts) { 
      {
        :operatingsystem => 'windows'
      }
    }
    
    it {
      should_not contain_package('zabbix').with({:ensure => 'present'})
      should_not contain_package('zabbix-agent').with({:ensure => 'present'})
    }
  end
end