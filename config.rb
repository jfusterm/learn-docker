# Number of Docker hosts
$num_instances = 1

# VMs prefix name
$vm_name_prefix = "docker"

# VM GUI
$vm_gui = false

# VM memory
$vm_memory = 2048

# VM CPUs
$vm_cpus = 1

# Docker release: main, testing, experimental
$docker_release = "main"

# Docker version: latest, 1.12.1, 1.12.0, 1.11.2...
$docker_version = "latest"

# Size of /var/lib/docker in GB
$var_lib_docker_size = 8

# Docker storage driver: aufs, devicemapper, overlay, overlay2, btrfs, zfs
$docker_storage_driver = "aufs"

# Display system and Docker information after login
$motd = true