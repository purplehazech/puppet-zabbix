source :rubygems

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 3.0']
end

gem 'puppet', puppetversion
gem 'hiera-module-json', '~> 0.0.2'
gem 'zabbixapi', ['>= 0.4.9']
# may be removed as soon as zabbixapi >= 0.5.1 is out
# see vadv/zabbixapi#7 for details :)
gem 'json', '~> 1.7.5'
 
group :test do
  gem 'rake', '>= 0.9.0'
  gem 'rspec', '>= 2.8.0'
  gem 'rspec-core', '>= 2.12.1'
  gem 'rspec-puppet', '>= 0.1.5'
  gem 'puppet-lint', '>= 0.3.2'
  gem 'puppetlabs_spec_helper', '>= 0.3.0'
  gem 'rspec-hiera-puppet', '>= 1.0.0'
end
