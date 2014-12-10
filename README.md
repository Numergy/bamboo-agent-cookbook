Bamboo-agent Cookbook [![Build Status](https://travis-ci.org/Numergy/bamboo-agent-cookbook.svg)](https://travis-ci.org/Numergy/bamboo-agent-cookbook)
================
A Chef cookbook for managing Bamboo agents.

It can:
- Install multiple agents side-by-side on a node
- Ensure agents are running / started up after a reboot
- Set properties in a agent's wrapper.conf
- Manage agent capabilities

This cookbook is based on the Puppet module: https://github.com/kayakco/puppet-bamboo_agent

Attributes
----------
#### bamboo-agent::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['bamboo-agent']['server']['address']</tt></td>
    <td>String</td>
    <td>Bamboo server address</td>
    <td><tt>localhost</tt></td>
  </tr>
  <tr>
    <td><tt>['bamboo-agent']['server']['protocol']</tt></td>
    <td>String</td>
    <td>Bamboo server protocol</td>
    <td><tt>localhost</tt></td>
  </tr>
  <tr>
    <td><tt>['bamboo-agent']['server']['port']</tt></td>
    <td>Integer/String</td>
    <td>Bamboo server port</td>
    <td><tt>8085</tt></td>
  </tr>
  <tr>
    <td><tt>['bamboo-agent']['install_dir']</tt></td>
    <td>String</td>
    <td>whether to install bamboo agents</td>
    <td><tt>/usr/local/bamboo</tt></td>
  </tr>
  <tr>
    <td><tt>['bamboo-agent']['installer_jar']</tt></td>
    <td>String</td>
    <td>whether to download the installer</td>
    <td><tt>"#{node['bamboo-agent']['install_dir']}/bamboo-agent-installer.jar"</tt></td>
  </tr>
  <tr>
    <td><tt>['bamboo-agent']['user']['name']</tt></td>
    <td>String</td>
    <td>The username for bamboo agents</td>
    <td><tt>bamboo</tt></td>
  </tr>
  <tr>
    <td><tt>['bamboo-agent']['user']['group']</tt></td>
    <td>String</td>
    <td>The group for bamboo agents</td>
    <td><tt>bamboo</tt></td>
  </tr>
  <tr>
    <td><tt>['bamboo-agent']['user']['manage']</tt></td>
    <td>Boolean</td>
    <td>If the user home must be managed</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['bamboo-agent']['user']['shell']</tt></td>
    <td>String</td>
    <td>The user shell</td>
    <td><tt>/bin/bash</tt></td>
  </tr>
  <tr>
    <td><tt>['bamboo-agent']['capabilities']</tt></td>
    <td>Hash</td>
    <td>The default capabilities</td>
    <td><tt>{}</tt></td>
  </tr>
  <tr>
    <td><tt>['bamboo-agent']['agents']</tt></td>
    <td>Hash</td>
    <td>Agents to deploy</td>
    <td><tt>{}</tt></td>
  </tr>
</table>

Usage
-----
#### bamboo-agent::default

```json
{
  "bamboo-agent": {
    "server": {
      "address": "my-bamboo-url"
    },
    "agents": [
      {"id":"1", "capabilities": {"system.builder.command.Bash": "/bin/bash"}},
      {"id":"2"}
    ]
  },
  "run_list": [
    "recipe[bamboo-agent]"
  ]
}
```

Running tests
-------------
This cookbook use Rake to run tests suites:  

- First install dependencies:  
`bundle install`  

- Run all checkstyle tests:  
`bundle exec rake test:checkstyle`  

- Run all rspec tests:  
`bundle exec rake test:specs`  

- Run all kitchen tests:  
`bundle exec rake test:kitchen`  

- Run all tests (checkstyle and rspec):  
`bundle exec rake test`  

Available tests suites:  
- Knife
- RuboCop
- Foodcritic
- ChefSpec
- Kitchen

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
|                      |                                             |
|:---------------------|:--------------------------------------------|
| **Author**           | Pierre Rambaud <pierre.rambaud@numergy.com> |
| **Author**           | Antoine Rouyer <antoine.rouyer@numergy.com> |
|                      |                                             |
| **Copyright**        | Copyright (c) 2014 Numergy                  |

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
