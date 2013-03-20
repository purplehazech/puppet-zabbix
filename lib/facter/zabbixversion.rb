Facter.add("zabbixversion") do
  distid = Facter.value('operatingsystem')
    case distid
    when "Gentoo"
      Facter::Util::Resolution.exec('eix --nocolor --pure-packages --format "<installedversions:VERSION>"  --stable --installed --name zabbix')
    when "Debian"
      version = Facter::Util::Resolution.exec('dpkg-query -W -f=\'${Version}\' zabbix-agent')
      array = version.split(":")
      array[array.size-1]
    end
  end
