$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../../../lib/ruby/")
require "zabbix"

Puppet::Type.type(:zabbix_mediatype).provide(:ruby) do
  desc "zabbix mediatype provider"
end