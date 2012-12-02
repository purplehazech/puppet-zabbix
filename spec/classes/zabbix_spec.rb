require 'spec_helper'

describe 'zabbix' do
  let :facts do 
    {
      :operatingsystem => 'Gentoo'
    }
  end
  it {
    should contain_class('zabbix::params')
    should contain_class('zabbix::gentoo')
    should contain_class('zabbix::agent')
  }
end
