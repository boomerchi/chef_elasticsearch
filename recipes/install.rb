#
# Cookbook Name:: raintank_elasticsearch
# Recipe:: install
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

include_recipe "java"
include_recipe 'elasticsearch'

elasticsearch_install 'elasticsearch'

elasticsearch_configure 'elasticsearch' do
  configuration({
    'node.name' => node.name,
    'network.host' => node['raintank_elasticsearch']['network_host'],
    'cluster.name' => node['raintank_elasticsearch']['cluster_name'],
    'http.bind_host' => node['raintank_elasticsearch']['http_bind_host']
  })
end

elasticsearch_plugin 'cloud-aws'
elasticsearch_plugin 'delete-by-query'

elasticsearch_service 'elasticsearch'

tag("elasticsearch")
