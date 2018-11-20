required_plugins = ["vagrant-hostsupdater", "vagrant-berkshelf"]
required_plugins.each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    # User vagrant plugin manager to install plugin, which will automatically refresh plugin list afterwards
    puts "Installing vagrant plugin #{plugin}"
    Vagrant::Plugin::Manager.instance.install_plugin plugin
    puts "Installed vagrant plugin #{plugin}"
  end
end

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"
  config.vm.network "private_network", ip: "192.168.10.35"
  config.hostsupdater.aliases = ["development.local"]

  config.vm.provision "chef_solo" do |chef|
      chef.add_recipe "elasticsearch::default"
    end
end
