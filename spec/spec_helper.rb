require 'rubygems'
require 'rspec-hiera-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.filter_run_excluding :broken => true
end

Puppet[:binder] = true

shared_context "hieradata" do
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
end
