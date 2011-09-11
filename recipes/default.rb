#
# Cookbook Name:: bind9
# Recipe:: default
#
# Copyright 2011, Mike Adolphs
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

package "bind9" do
  case node[:platform]
  when "centos", "redhat", "suse", "fedora"
    package_name "bind"
  when "debian", "ubuntu"
    package_name "bind9"
  end
  action :install
end

service "bind9" do
  supports :status => true, :reload => true, :restart => true
  action [ :enable, :start ]
end

#template "/etc/bind/named.conf.local" do
#  source "named.conf.local.erb"
#  owner "root"
#  group "root"
#  mode 0644
#end

template "/etc/bind/named.conf.options" do
  source "named.conf.options.erb"
  owner "root"
  group "root"
  mode 0644
end

search(:zones) do |zone|
  template "/etc/bind/named.conf.local" do
    source "named.conf.local.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      "domain" => zone[:domain],
      "type" => zone[:type],
      "allow_transfer" => zone[:allow_transfer]
  })
  end
end