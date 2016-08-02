#
# Cookbook Name:: chef_elasticsearch
# Recipe:: eventtank
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

packagecloud_repo node[:chef_elasticsearch][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['chef_elasticsearch']['eventtank']['version']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "eventtank" do
  version pkg_version
  action pkg_action
  options "-o Dpkg::Options::='--force-confnew'"
end

service "eventtank" do
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 15.04
      provider Chef::Provider::Service::Systemd
    elsif node["platform_version"].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [ :enable, :start ]
end

haproxy_addr = find_haproxy

kafka_addr = if haproxy_addr.nil?
  node['chef_elasticsearch']['eventtank']['kafka_addr']
else
  "#{haproxy_addr}:9092"
end

elastic_addr = if haproxy_addr.nil?
  node['chef_elasticsearch']['eventtank']['elastic_addr']
else
  "#{haproxy_addr}:9200"
end

template "/etc/raintank/eventtank.ini" do
  source "eventtank.ini.erb"
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  variables({
    topic: node['chef_elasticsearch']['eventtank']['topic'],
    group: node['chef_elasticsearch']['eventtank']['group'],
    kafka_addr: kafka_addr,
    elastic_addr: elastic_addr,
    statsd_addr: node['chef_elasticsearch']['eventtank']['statsd_addr']
  })
  notifies :restart, "service[eventtank]"
end
