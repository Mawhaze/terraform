resource "proxmox_vm_qemu" "proxmox_vm" {
  name = var.vm_name
  target_node = var.instance_config[var.host_node][var.node_size].target_node
  tags = var.instance_config[var.host_node][var.node_size].tags
  desc= var.instance_config[var.host_node][var.node_size].description
  clone = var.instance_config[var.host_node][var.node_size].template_vm_name
  bios = var.bios
  full_clone = true
  agent = 1
  memory = var.instance_config[var.host_node][var.node_size].vm_memory
  cores = var.instance_config[var.host_node][var.node_size].vm_cores
  scsihw = "virtio-scsi-single"
  ipconfig0 = "ip=dhcp"
  disks {
    scsi {
      scsi0 {
        disk {
          size = var.instance_config[var.host_node][var.node_size].vm_disk_size
          storage = var.instance_config[var.host_node][var.node_size].vm_storage
          emulatessd = true
          iothread = true
        }
      }  
    }
  }
}