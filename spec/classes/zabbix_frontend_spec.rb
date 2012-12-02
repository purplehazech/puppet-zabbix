require 'spec_helper'

describe 'zabbix::agent' do
  
  context "on gentoo" do
    let(:facts) { 
      {
        :operatingsystem => 'Gentoo'
      }
    }
    it {
      should contain_file('/etc/portage/package.use/10_zabbix__frontend')
      should contain_package('zabbix').with({:ensure => 'present'})
      should contain_file('/etc/zabbix/zabbix_agentd.conf')
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
      should_not contain_package('zabbix-frontend').with({:ensure => 'present'})
    }
  end
end