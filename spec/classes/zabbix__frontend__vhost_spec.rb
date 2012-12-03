require 'spec_helper'

describe 'zabbix::frontend::vhost' do

  context "on gentoo" do
    let(:facts) { 
      {
        :fqdn            => 'f.q.d.n.example.com',
        :operatingsystem => 'Gentoo',
      }
    }
    it {
      should contain_class('apache')
      should contain_apache__vhost('f.q.d.n.example.com').with({
        :docroot         => '/var/www/f.q.d.n.example.com/htdocs',
        :vhost_name      => 'f.q.d.n.example.com',
        :port            => '80',
      })
    }
  end
end
