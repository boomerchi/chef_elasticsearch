#
# Cookbook Name:: chef_elasticsearch
# Recipe:: disks
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

include_recipe 'elasticsearch'

elasticsearch_user 'elasticsearch'

directory '/usr/local/var/data/elasticsearch' do
  owner "elasticsearch"
  group "elasticsearch"
  mode "0755"
  recursive true
  action :create
end

unless node[:chef_base][:is_img_build]
  include_recipe "lvm"
  lvm_volume_group 'elasticsearch00' do
    physical_volumes [ node['chef_elasticsearch']['elasticsearch_disk'] ]

    logical_volume 'elasticsearch' do
      size        '100%VG'
      filesystem  'ext4'
      stripes     1
    end
  end
  mount '/usr/local/var/data/elasticsearch' do
    device '/dev/mapper/elasticsearch00-elasticsearch'
    fstype 'ext4'
    options 'noatime,nodiratime'
    action [ :mount, :enable ]
  end
end
