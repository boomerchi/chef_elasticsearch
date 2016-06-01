#
# Cookbook Name:: chef_elasticsearch
# Recipe:: es_solo
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

# ONLY run this recipe if this elasticsearch server is intended to run alone.
# It MUST not be run on a cluster of elasticsearch servers.

bash 'standalone_elastic' do
  cwd "/tmp"
  code <<-EOH
    /usr/bin/curl -X PUT http://localhost:9200/_settings -d '{
     "index" : {
         "number_of_replicas" : 0
    }
   }'
  EOH
  only_if { !node['chef_elasticsearch']['standalone'] }
end
