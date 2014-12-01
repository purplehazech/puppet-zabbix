require 'rubygems'
require 'rspec-hiera-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'simplecov'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

SimpleCov.start

RSpec.configure do |c|
  c.filter_run_excluding :broken => true
end

shared_context "hieradata" do
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
end

shared_context "puppet_binder" do
  before(:each) do
    Puppet[:binder] = true

    #Puppet::Util::Log.level = :debug
    #Puppet::Util::Log.newdestination(:console)
  end
end

at_exit { RSpec::Puppet::Coverage.report! }
