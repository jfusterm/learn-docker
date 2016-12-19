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

      if $forwarded_ports.length > 0
        $forwarded_ports.each do |key, value|
          config.vm.network "forwarded_port", guest: key, host: value, auto_correct: true
        end
      end

      if $synced_folders.length > 0
        $synced_folders.each do |key, value|
          config.vm.synced_folder key, value
        end
      end

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

      # Install Docker Compose
      config.vm.provision :shell, :inline => "curl -L https://github.com/docker/compose/releases/download/#{$compose_version}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose"
      config.vm.provision :shell, :inline => "chmod +x /usr/local/bin/docker-compose"

      if $networking_plugins
        # Get Etcd
        config.vm.provision :shell, :inline => "curl -Lo etcd.tar.gz  https://github.com/coreos/etcd/releases/download/v#{$etcd_version}/etcd-v#{$etcd_version}-linux-amd64.tar.gz"
        config.vm.provision :shell, :inline => "tar -xvzf etcd.tar.gz -C /usr/local/bin/ --strip-components=1 --wildcards etcd-v#{$etcd_version}-linux-amd64/etcd*"
        config.vm.provision :shell, :inline => "rm -f etdc.tar.gz"

        # Get Calico
        config.vm.provision :shell, :inline => "curl -Lo /usr/local/bin/calicoctl https://github.com/projectcalico/calico-containers/releases/download/v#{$calico_version}/calicoctl"
        config.vm.provision :shell, :inline => "chmod +x /usr/local/bin/calicoctl"

        # Get Weave
        config.vm.provision :shell, :inline => "curl -Lo /usr/local/bin/weave git.io/weave"
        config.vm.provision :shell, :inline => "chmod +x /usr/local/bin/weave"

        # Get Flannel
        config.vm.provision :shell, :inline => "curl -Lo /usr/local/bin/flanneld https://github.com/coreos/flannel/releases/download/v#{$flannel_version}/flanneld-amd64"
        config.vm.provision :shell, :inline => "chmod +x /usr/local/bin/flanneld"

        # Download Docker images
        config.vm.provision :docker, images: ["calico/node:v#{$calico_version}","weaveworks/weaveexec:#{$weave_version}","weaveworks/weave:#{$weave_version}","weaveworks/plugin:#{$weave_version}"]
      end
    end
  end
end
