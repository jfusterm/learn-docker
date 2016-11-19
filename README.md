# learn-docker

New to [Docker](https://www.docker.com/)? Want to learn what containers are and how Docker handle them?

Using Vagrant you can create easily a virtual machine using Virtualbox on your local machine with Docker up and running. The setup has been prepared to run under Ubuntu 16.04 (aka Xenial Xerus).

## Requirements

* [Virtualbox](https://www.virtualbox.org/) ≥ 5.1.x
* [Vagrant](https://www.vagrantup.com/) ≥ 1.8.6

## Usage

1) Clone the repository

```
$ git clone https://github.com/jfusterm/learn-docker.git
$ cd learn-docker
```

2) Launch the VM

```
$ vagrant up
```

3) Connect to the VM

```
$ vagrant ssh
```

If you launch more than 1 VM, you can connect using the VM name.

```
$ vagrant ssh docker-01
```

4) Check that Docker is up and running

```
$ docker info
```

## Configuration

You can adjust your Docker environment changing the options included in the configuration file `config.rb`

* **`$num_instances`**. By default, Vagrant will create just 1 virtual machine. If you want to test [Docker Swarm](https://www.docker.com/products/docker-swarm), you should increase this variable to at least `3` and Vagrant will create as many instances as you define.

```
$ vagrant status

Current machine states:

docker-01                 running (virtualbox)
docker-02                 running (virtualbox)
docker-03                 running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

* **`$vm_name_prefix`**. Prefix used to define the VMs name.
* **`$vm_gui`**. If you want to start the VM with GUI, set this to `true`.
* **`$vm_memory`**. Amount of memory assigned to the VM.
* **`$vm_cpus`**. Number of CPUs assigned to the VM.
* **`$forwarded_ports`**. Port forwarding from the host to the guest expressed in a `hash`.

```
$forwarded_ports = { 8080 => 8080, 8081 => 8081 }
```

* **`$synced_folders`**. Synced folders from the host to the guest expressed in a `hash`.

```
$synced_folders = { "/home/joan/code" => "/code" }
```

* **`$docker_release`**. Which release of Docker will be used.

	* `main`. Stable release.
	* `testing`. For test builds (ie. release candidates).
	* `experimental`. For experimental builds with the next Docker version.

* **`$docker_version`**. Version of Docker that will be installed. Unless you need a specific version to test a feature or bug, leave it as `latest`.
* **`$var_lib_docker_size`**. Size of `/var/lib/docker` in GB. Docker's root directory will be mounted in a separate hard drive that Vagrant will create at boot time. The hard drive will be created in the same directory with the name `var-lib-docker-XX.vmdk`, being `XX` the instance number.
* **`$docker_storage_driver`**. Which [Docker storage driver](https://docs.docker.com/engine/userguide/storagedriver/selectadriver/) will be used.
* **`$motd`**. If `true`, after login you will see both system and Docker information.

```
  SYSTEM

  Hostname:        docker-01
  OS:              Ubuntu 16.04.1 LTS
  Kernel Version:  4.4.0-36-generic
  Architecture:    x86_64
  CPUs:            1
  Total Memory:    992.4 MiB
  IP:              192.168.42.12/24

  DOCKER

  Containers:      0 => [ Running: 0 | Paused: 0 | Stopped: 0 ]
  Images:          0
  Server Version:  1.12.1
  API Version:     1.24
  Storage Driver:  aufs
  Root Dir:        /var/lib/docker
  Root Dir Size:   7.8G
  Config File:     /etc/docker/daemon.json
```
