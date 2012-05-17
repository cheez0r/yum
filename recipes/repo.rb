#
# Cookbook Name:: yum
# Recipe:: repo
#
# Copyright 2011, Rackspace
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

include_recipe "nginx::default"

package "createrepo" do
  action :install
end

directory node[:yum][:repo_base_directory] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  not_if do File.exists?(node[:yum][:repo_base_directory]) end
end

bash "createrepo" do
  cwd node[:yum][:repo_base_directory]
  user "root"
  code <<-EOH
    mv #{node[:yum][:upload_packages_dir]}/*.rpm .
    createrepo .
  EOH
end
