require 'spec_helper'

describe 'zabbix::agent' do
  include_context "puppet_binder"

  context "on debian" do
    include_context "hieradata"
    let(:facts) { 
      {
        :operatingsystem => 'Debian'
      }
    }
    it {
      should contain_package('zabbix-agent').with({:ensure => 'installed'})
      should contain_file('/etc/zabbix/zabbix_agentd.conf')
      should contain_service('zabbix-agent').with({
        :ensure => 'running',
        :enable => 'true'
      })
    }
  end
  context "on gentoo" do
    include_context "hieradata"
    let(:facts) { 
      {
        :osfamily => 'Gentoo'
      }
    }
    it {
      should contain_package('zabbix').with({:ensure => 'installed'})
      should contain_file('/etc/zabbix/zabbix_agentd.conf')
      should contain_service('zabbix-agentd').with({
        :ensure => 'running',
        :enable => 'true'
      })
    }
  end
end
