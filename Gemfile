source :rubygems

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 2.7']
end

gem 'puppet', puppetversion
 
group :test do
  gem 'rake', '>= 0.9.0'
  gem 'rspec', '>= 2.8.0'
  gem 'rspec-puppet', '>= 0.1.1'
  gem 'puppet-lint', '>= 0.3.2'
  gem 'puppetlabs_spec_helper', '>= 0.3.0'
end
