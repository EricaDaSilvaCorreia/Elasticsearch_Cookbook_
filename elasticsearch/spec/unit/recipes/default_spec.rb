#
# Cookbook:: elasticsearch
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'elasticsearch::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it "runs apt get update" do
      expect(chef_run).to update_apt_update 'update_sources'
    end

    it 'should install java' do
      expect(chef_run).to install_package "default-jre"
    end

    it 'should install elasticsearch' do
      expect(chef_run).to install_package "elasticsearch"
    end

    it "should delete /etc/elasticsearch/elasticsearch.yml" do
     expect(chef_run).to delete_link('/etc/elasticsearch/elasticsearch.yml')
   end

    it "should delete /etc/elasticsearch/jvm.options" do
     expect(chef_run).to delete_link('/etc/elasticsearch/jvm.options')
   end

   it "should create file elasticsearch.yml in /etc/elasticsearch/" do
      expect(chef_run).to create_template('/etc/elasticsearch/elasticsearch.yml')
    end

   it "should create file jvm.options in /etc/elasticsearch/" do
      expect(chef_run).to create_template('/etc/elasticsearch/jvm.options')
    end

    it 'should enable the elasticsearch service' do
      expect(chef_run).to enable_service "elasticsearch"
    end

    it 'should start the elasticsearch service' do
      expect(chef_run).to start_service "elasticsearch"
    end

  end
end
