Facter.add("zabbixversion") do
  setcode do
    Facter::Util::Resolution.exec('eix --nocolor --pure-packages --format "<installedversions:VERSION>"  --stable --installed --name zabbix')
  end
end