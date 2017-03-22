# Number of Docker hosts
$num_instances = 1

# VMs prefix name
$vm_name_prefix = "docker"

# VM GUI
$vm_gui = false

# VM memory
$vm_memory = 1024

# VM CPUs
$vm_cpus = 1

# Forwarded ports { guest => host }
$forwarded_ports = {}

# Synced folders { host => guest }
$synced_folders = {}

# Docker release: main, testing, experimental
$docker_release = "main"

# Docker version: latest, 1.12.1, 1.12.0, 1.11.2...
$docker_version = "latest"

# Docker Compose version: 1.9.0, 1.8.1...
$compose_version = "1.11.2"

# Size of /var/lib/docker in GB
$var_lib_docker_size = 8

# Docker storage driver: aufs, devicemapper, overlay, overlay2, btrfs, zfs
$docker_storage_driver = "overlay2"

# Display system and Docker information after login
$motd = true

# Install different Docker networking plugins: Calico, Weave and Flannel
$networking_plugins = false

$calico_version = "1.1.0"
$weave_version = "1.9.4"
$flannel_version = "0.7.0"
$etcd_version = "3.1.2"
