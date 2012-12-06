
describe 'zabbix::externals' do
  
  context 'should have params' do
    let :param do
      {
        :ensure => 'undef',
      }
    end
    it {
      should contain_class('zabbix::externals')
    }
  end
  
  context 'should load params' do
    it {
      should contain_class('zabbix::params')
    }
  end
  
end