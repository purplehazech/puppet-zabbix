# Module: Zabbix

[![Build Status](https://travis-ci.org/purplehazech/puppet-zabbix.svg?branch=develop)](https://travis-ci.org/purplehazech/puppet-zabbix)

Install and configure Zabbix.

This module aims to be a feature complete module for Zabbix. Right 
now it is being developed and tested on Gentoo and Debian/Ubuntu.
I plan on porting it over to multiple architectures later on. 
This modules uses the ``git-flow`` model and the main development branch
is ``develop``. For versioning this module adheres to semver.org.

In my opinion a feature complete Zabbix module must support the 
following things.

* Zabbix reports from puppet
  
  supported by doing a subtree merge of 
  [thomasvandoren/puppet-zabbix](https://github.com/thomasvandoren/puppet-zabbix)

* ability to separately manage Zabbix server, frontend and agent
* additional apps like proxy, alternative agents (snmp + more)
  
  not hard to do, but bumped to later since i don't need them
* complete api integration for provisioning
  
  plans are to host every single line of Zabbix config
  in puppet data somewhere. You never need to touch the 
  config part of the frontend. The second version of the
  API seems to work, Zabbix's api has some quirks and i needed
  to find those first.
  This is under development in the ``develop`` branch and will
  not hit master before it's complete. The version in master is 
  considered unsuitable for any use other that finding out how 
  not to code ruby.
* documentation
  
  containing all the (double) spaceship examples to explain 
  why it makes sense to use the Zabbix api this way.

At this point most of the legwork is done. This module will hit
the 1.x milestone as soon as it is ready for produciton on gentoo
and debian/ubuntu.
  
## Development

You might want to look here for a howtos:

* https://github.com/purplehazech/puppet-module_template
* https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/RELEASE_PROCESS.markdown

This modules is released under the Affero GPL. This means you will have to
contribute all changes back to the community.

For the most part I try to proactively merge changes from forks. Pull
requests are very welcome as well.

## License

2012, Lucas S. Bickel, Alle Rechte vorbehalten

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

### Zabbix Report Processor

Zabbix Report Processor is in this program as a subtree merge.

Author: Thomas Van Doren

License: GPLv2

Github: https://github.com/thomasvandoren/puppet-zabbix
