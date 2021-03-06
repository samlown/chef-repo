#/postgresql.conf.
# Cookbook Name:: postgresql
# Recipe:: server
#
# Copyright 2009, Opscode, Inc.
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
#

include_recipe "postgresql::client" 

package "postgresql"

directory "#{node[:postgresql][:data_dir]}" do 
  owner "postgres"
  group "postgres"
  mode "0700"
  recursive true
  action :create
end

execute "initdb" do
  command "/usr/lib/postgresql/8.4/bin/initdb -D #{node[:postgresql][:data_dir]}"
  user "postgres"
  creates File.join(node[:postgresql][:data_dir], "PG_VERSION")
end

service "postgresql" do
  case node[:platform]
  when "debian","ubuntu"
    service_name "postgresql-8.4"
  end
  supports :restart => true, :status => true, :reload => true
  action :nothing
end

template "#{node[:postgresql][:dir]}/pg_hba.conf" do
  source "pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :reload, resources(:service => "postgresql")
end

template "#{node[:postgresql][:dir]}/postgresql.conf" do
  source "postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :restart, resources(:service => "postgresql")
end
