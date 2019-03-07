#
# Cookbook:: artifactory
# Recipe:: db
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

template "#{node['artifactory']['config_path']}/db.properties" do
  source "#{node['artifactory']['db']['type']}.properties.erb"
  variables(
    'db_host' => node['artifactory']['db']['host'],
    'db_port' => node['artifactory']['db']['port'],
    'db_name' => node['artifactory']['db']['name'],
    'db_user' => node['artifactory']['db']['user'],
    'db_password' => node['artifactory']['db']['password']
  )
  user node['artifactory']['user']
end

# Pull down the right JDBC driver
remote_file "#{node['artifactory']['jdbc_driver_path']}/#{node['artifactory']['db_jar_file']}" do
  source node['artifactory']['jdbc_driver_url']
  action :create
  user node['artifactory']['user']
end
