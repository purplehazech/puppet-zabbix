require 'spec_helper'

describe 'zabbix::agent::param' do
  let(:params) {
    {
      :path => '/tmp/test',
      :index => '10',
      :key => 'test.test',
    }
  }
  it {
    should contain_file('/tmp/test/10-test.test.config')
  }
end