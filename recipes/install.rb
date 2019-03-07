#
# Cookbook:: artifactory
# Recipe:: install
#
# Copyright:: 2018, Lucas Mariani
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
build_essential 'compile tools' do
  compile_time true
end

chef_gem 'rest-client' do
  action :install
end

node.default['java']['jdk_version'] = node['artifactory']['java_version']
include_recipe 'java' if node['artifactory']['java_install'] == true

package 'rsync' do
  action :install
end

# Download the Artifactory RPM
remote_file "#{Chef::Config[:file_cache_path]}/#{node['artifactory']['package_name']}-#{node['artifactory']['package_version']}.rpm" do
  source node['artifactory']['package_url']
  action :create_if_missing
end

# Install the Artifactory RPM
rpm_package node['artifactory']['package_name'] do
  allow_downgrade false
  source "#{Chef::Config[:file_cache_path]}/#{node['artifactory']['package_name']}-#{node['artifactory']['package_version']}.rpm"
  action :install
end

template "#{node['artifactory']['home']}/tomcat/conf/server.xml" do
  source 'server.xml.erb'
  owner node['artifactory']['user']
  group node['artifactory']['group']
  mode '0744'
end

template "#{node['artifactory']['config_path']}/artifactory.system.properties" do
  source 'artifactory.system.properties.erb'
  owner node['artifactory']['user']
  group node['artifactory']['group']
  variables(
    properties: node['artifactory']['properties']
  )
  mode '0744'
end

include_recipe 'artifactory::db' unless node['artifactory']['db']['type'] == 'derby'

include_recipe 'artifactory::activate' if node['artifactory']['activate']

service node['artifactory']['service_name'] do
  supports status: true, restart: true
  action [:enable, :start]
end

artifactory_api_status 'check_api' do
  api_server "http://localhost:8081/artifactory/api"
end
