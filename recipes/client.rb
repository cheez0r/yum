#
# Cookbook Name:: yum
# Recipe:: client
#
# Copyright 2010, Rackspace
#
# All rights reserved - Do Not Redistribute

ruby_block "wait_till_repo_loaded" do
	block do
		require 'net/http'

		repo_loaded=false
		until repo_loaded == true do

			begin
			if Net::HTTP.get_response(URI.parse("#{node[:yum][:repo_url]}/repodata/repomd.xml")).class == Net::HTTPOK
				repo_loaded=true
				Chef::Log.info("Yum repo is online.")
			else
				Chef::Log.info("Waiting on Yum repo to load...")
				sleep 5
			end
			rescue
				Chef::Log.info("Waiting on Yum repo to load...")
				sleep 5
			end

		end
	end
	not_if do File.exists?("/etc/yum.repos.d/#{node[:yum][:repo]}.repo") end
end

template "/etc/yum.repos.d/#{node[:yum][:repo]}.repo" do
  source "yum_client.repo.erb"
  mode 0440
  owner "root"
  group "root"
end
