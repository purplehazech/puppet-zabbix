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
      should contain_file_line('zabbix-db').with({
        :path            => '/var/www/f.q.d.n.example.com/htdocs'
      })
      should contain_apache__vhost__include__php('zabbix').with({
        :vhost_name      => 'f.q.d.n.example.com',
        :envs            => [
          'date.timezone = Europe/Zurich', 
          'post_max_size = 32M', 
          'max_execution_time = 600', 
          'max_input_time = 600'
        ]
      })
    }
  end
end
