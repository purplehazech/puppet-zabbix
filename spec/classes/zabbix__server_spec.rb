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
      should contain_file('/etc/zabbix/zabbix_server.conf')
    }
  end
  context 'it should have params' do
    let(:params) {
      {
        :ensure      => 'present',
        :conf_file   => 'undef',
        :template    => 'undef',
        :node_id     => 'undef',
        :db_server   => 'undef',
        :db_database => 'undef',
        :db_user     => 'undef',
        :db_password => 'undef',
      }
    }
  end
end