#
# Cookbook:: elasticsearch
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
apt_update 'update_sources' do
  action :update
end

package 'default-jre'
package 'elasticsearch'
package 'curl'

# apt_repository 'mongodb-org' do
#   uri "http://repo.mongodb.org/apt/ubuntu"
#   distribution "xenial/mongodb-org/3.2"
#   components ['multiverse']
#   keyserver "hkp://keyserver.ubuntu.com:80"
#   key "EA312927"
# end

package 'elasticsearch' do
  action :upgrade
end

service 'elasticsearch' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

link '/etc/elasticsearch/elasticsearch.yml' do
  action :delete
end

link '/etc/elasticsearch/jvm.options' do
  action :delete
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml.erb'
  notifies :restart, 'service[elasticsearch]'
end

template '/etc/elasticsearch/jvm.options' do
  source 'jvm.options.erb'
  notifies :restart, 'service[elasticsearch]'
end
