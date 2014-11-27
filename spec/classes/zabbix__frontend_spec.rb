require 'spec_helper'

describe 'zabbix::frontend' do
  include_context "puppet_binder"
  include_context "hieradata"

  # only support gentoo for frontends as of now
  let(:facts) {
    {
      :operatingsystem => 'Gentoo',
    }
  }
  context "on gentoo" do
    let(:facts) { 
      {
        :fqdn            => 'f.q.d.n.example.com',
        :operatingsystem => 'Gentoo',
        :osfamily        => 'Gentoo',
      }
    }
    let(:params) {
      {
        :ensure  => true,
        :version => '2.0.3',
      }
    }
    it {
      should contain_class('zabbix::frontend::vhost').with({
        :ensure    => true,
        :vhostname => 'f.q.d.n.example.com'
      })
    }
  end
  
  context "configure frontend" do

    let(:facts) { 
      {
        :fqdn            => 'f.q.d.n.example.com',
        :operatingsystem => 'Gentoo',
        :osfamily        => 'Gentoo',
      }
    }
    let(:params) {
      {
        :ensure  => 'present',
        :version => '2.0.3',
      }
    }
    it {
      should contain_file('/var/www/f.q.d.n.example.com/htdocs/zabbix/conf/zabbix.conf.php')
    }
  end
end
