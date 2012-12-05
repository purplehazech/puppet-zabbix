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
        :export      => 'undef',
        :hostname    => 'undef',
      }
    }
  end
  context 'test zabbix::server::template call with args', :broken => true do
    # broken due to dependency on rodjek/rspec-puppet#51
    let(:exported_resources) { 
      {
        'zabbix::server::template' => {
          'test_template' => {
            'ensure' => 'present',
          }
        }
      }
    }
    it {
      should contain_zabbix__server__template('test_template').with({
        :ensure => 'present'
      })
    }
  end
  context 'with export present', :broken => true do
    # testing exported resources seems generally broken
    # i would like to test this side for proper exporting
    # and then test it on the other side again like above
    let(:facts) {
      {
        :operatingsystem => 'Gentoo',
        'fqdn' => 'server_host'
      }
    }
    let(:params) {
      {
      'export' => 'present',
      }
    }
    it {
      should contain_zabbix__agent__server('server_host').with({
        :ensure   => 'present',
        :hostname => 'server_host'
      })
    }
  end
  context 'should always require an agent'
    it {
      should contain_zabbix__agent('zabbix::agent').with({
        :ensure   => present,
      })
    }
  end
end
