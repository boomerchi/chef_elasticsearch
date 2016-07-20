#
# Cookbook Name:: chef_elasticsearch
# Recipe:: collectd
#
# Copyright (C) 2016 Raintank, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

directory "/usr/share/collectd/plugins" do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
  only_if { node['use_collectd'] }
end

if node['use_collectd'] && node['collectd']['python_plugins']['elasticsearch-collectd']
  node.set['collectd']['python_plugins']['elasticsearch-collectd']['module_config']['Cluster'] = node['chef_elasticsearch']['cluster_name']
end

package 'python-pip'
package 'python-dev'

bash 'install_elasticsearch_python_modules' do
  cwd "/tmp"
  code "pip install elasticsearch; pip install collectd"
end

cookbook_file "/usr/share/collectd/plugins/elasticsearch-collectd.py" do
  source 'elasticsearch.py'
  owner 'root'
  group 'root'
  mode '0755'
  only_if { node['use_collectd'] }
  action :create  
end

node.set["collectd_personality"] = "elasticsearch"
include_recipe "chef_base::collectd"
