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

execute "get key" do
  command 'echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list'
end

package 'elasticsearch'

package 'elasticsearch' do
  action :upgrade
end

service 'elasticsearch' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

execute "modify permissions" do
  command "sudo chmod 777 /etc/elasticsearch"
end
execute "move elasticsearch.yml file" do
  command "sudo mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.old"
end

execute "move jvm.options file" do
  command "sudo mv /etc/elasticsearch/jvm.options /etc/elasticsearch/jvm.options.old"
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml.erb'
  notifies :restart, 'service[elasticsearch]'
end

template '/etc/elasticsearch/jvm.options' do
  source 'jvm.options.erb'
  notifies :restart, 'service[elasticsearch]'
end

# link '/etc/elasticsearch/elasticsearch.yml' do
#   to '/etc/elasticsearch/elasticsearch.yml'
# end
#
# link '/etc/elasticsearch/jvm.options' do
#   to '/etc/elasticsearch/jvm.options'
# end
#
# link '/etc/elasticsearch/elasticsearch.yml' do
#   action :delete
# end
#
# link '/etc/elasticsearch/jvm.options' do
#   action :delete
# end
