# -*- mode: ruby -*-
# vi: set ft=ruby :

CONFIG = File.join(File.dirname(__FILE__), "config.rb")

if File.exist?(CONFIG)
  require CONFIG
end

Vagrant.configure("2") do |config|
  (1..$num_instances).each do |i|

    config.vm.box = "ubuntu/xenial64"

    config.vm.define vm_name = "%s-%02d" % [$vm_name_prefix, i] do |config|
    
      config.vm.hostname = vm_name

      ip = "192.168.42.#{i+10}"
      config.vm.network :private_network, ip: ip

      config.vm.provider :virtualbox do |vb|

        vb.gui = $vm_gui
        vb.memory = $vm_memory
        vb.cpus = $vm_cpus
        vb.check_guest_additions = false

        $var_lib_docker = File.join(File.dirname(__FILE__), "var-lib-docker-" + "%02d" % [i] + ".vmdk")

        if ! File.exist?($var_lib_docker)
          vb.customize ['createhd', '--filename', $var_lib_docker, '--size', $var_lib_docker_size * 1024, '--format', "VMDK"]
          vb.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', $var_lib_docker]
        end
      end

      config.vm.provision "file", source: "./files/daemon.json", destination: "/tmp/daemon.json"
      
      if $motd
        config.vm.provision "file", source: "./files/motd", destination: "/tmp/motd"
      end
    
      if ["btrfs", "zfs"].include? $docker_storage_driver
        $var_lib_docker_fs = $docker_storage_driver
      else
        $var_lib_docker_fs = "ext4"
      end

      config.vm.provision "shell", path: "./scripts/bootstrap.sh", args: ["#{$var_lib_docker_fs}", "#{$docker_storage_driver}", "#{$docker_release}", "#{$docker_version}"]

    end
  end
end
