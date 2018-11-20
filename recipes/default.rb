#
# Cookbook:: elasticsearch
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
apt_update 'update_sources' do
  action :update
end

package 'default-jre'

execute "install elasticsearch" do
  command "wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -"
end

execute "install apt-transport" do
  command "sudo apt-get install apt-transport-https"
end

execute "get key" do
  command "echo 'deb https://artifacts.elastic.co/packages/6.x/apt stable main' | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list"
end

execute "update all" do
  command "sudo apt-get update"
end

package 'elasticsearch'

service 'elasticsearch' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml.erb'
  notifies :restart, 'service[elasticsearch]'
end

template '/etc/elasticsearch/jvm.options' do
  source 'jvm.options.erb'
  notifies :restart, 'service[elasticsearch]'
end

execute "start elasticsearch" do
  command "sudo service elasticsearch start"
end
