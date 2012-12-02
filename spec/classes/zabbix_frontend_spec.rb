require 'spec_helper'

describe 'zabbix::frontend' do
  
  context "on gentoo" do
    let(:facts) { 
      {
        :operatingsystem => 'Gentoo',
        :fqdn => 'f.q.d.n.example.com',
        :id => 'id'
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
      should contain_class('apache').with({
        :serveradmin => 'id@f.q.d.n.example.com'
      })
      should contain_apache__vhost('f.q.d.n.example.com').with({
        :docroot         => '/var/www/f.q.d.n.example.com/htdocs',
        :priority        => '10',
        :vhost_name      => 'f.q.d.n.example.com',
        :port            => '80',
      })
      should contain_webapp_config('zabbix').with({
        :action => 'install', 
        :vhost => 'f.q.d.n.example.com',
        :base => '/zabbix', 
        :app => 'zabbix', 
        :version => '2.0.3'
      })
    }
  end
end
