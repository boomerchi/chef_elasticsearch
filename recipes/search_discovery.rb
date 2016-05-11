#
# Cookbook Name:: raintank_elasticsearch
# Recipe:: search_discovery
#
#
# Copyright 2016 Karel Minarik (karmi@elasticsearch.com) and contributors
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
# Taken from an older version of the elasticsearch cookbook.
#
# This recipe configures the cluster to use Chef search for discovering Elasticsearch nodes.
# This allows the cluster to operate without multicast, without AWS, and without having to manually manage nodes.
#
# By default it will search for other nodes with the query
# `role:elasticsearch AND chef_environment:#{node.chef_environment} AND elasticsearch_cluster_name:#{node[:elasticsearch][:cluster][:name]}`, but you may override that with the
# `node['elasticsearch']['discovery']['search_query']` attribute.
#
# Reasonable values include
# `"tag:elasticsearch AND chef_environment:#{node.chef_environment}"` and
# `"(role:es-server OR role:es-client) AND chef_environment:#{node.chef_environment}"`.
#
# By default it will attempt to select a reasonable IP address for each
# node, using `node['cloud']['local_ipv4']` on cloud servers, and
# `node['ipaddress']` elsewhere.
#
# You may override that with the
# `node'elasticsearch']['discovery']['node_attribute']` attribute.
# Reasonable values include `"fqdn"` and `"cloud.public_ipv4`.
#
node.set['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false
nodes = search_for_nodes(node['elasticsearch']['discovery']['search_query'],
                         node['elasticsearch']['discovery']['node_attribute'])
Chef::Log.debug("Found elasticsearch nodes at #{nodes.join(', ').inspect}")
node.set['elasticsearch']['discovery']['zen']['ping']['unicast']['hosts'] = nodes.join(',')

# set minimum_master_nodes to n/2+1 to avoid split brain scenarios
node.default['elasticsearch']['discovery']['zen']['minimum_master_nodes'] = (nodes.length / 2).floor + 1

# we don't want all of the nodes in the cluster to restart when a new node joins
node.set['elasticsearch']['skip_restart'] = true
