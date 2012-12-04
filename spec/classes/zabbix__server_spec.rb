require 'spec_helper'

describe 'zabbix::server' do
  context 'on gentoo' do
    let(:facts) {
      {
        :operatingsystem => 'Gentoo',
        :osfamily => 'gentoo',
      }
    }
    it {
      should contain_class('zabbix::server::gentoo')
      should contain_service('zabbix-server').with({
        :ensure => 'running',
        :enable => 'true',
      })
    }
  end
  context 'it should have valid params' do
    let(:params) {
      {
        :ensure => 'present',
      }
    }
  end
end