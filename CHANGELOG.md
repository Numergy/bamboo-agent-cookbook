Bamboo-agent CHANGELOG
=================

This file is used to list changes made in each version of the bamboo-agent cookbook.

0.7.0
-----
- Use boxes store on http://opscode-vm-bento.s3.amazonaws.com/ for kitchen.yml
- Service bamboo agent must supports restart and status to prevent errors when start action is used
- Update init script to include LSBInitScripts (https://wiki.debian.org/LSBInitScripts)

0.6.0
-----
- Update dependencies

0.5.0
-----
- Missing build-essential cookbook

0.4.0
-----
- Licensing, and Chefspec matchers

0.3.0
-----
- Add resource and provider to allow the installation of a agent

0.2.0
-----
- Debian and CentOs support

0.1.0
-----
- Initial release of bamboo-agent

