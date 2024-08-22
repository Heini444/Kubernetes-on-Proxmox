# k8s-vm-control-plane.tf
resource "proxmox_virtual_environment_vm" "k8s-ctrl-01" {
  provider  = proxmox.ussvirt
  node_name = var.ussvirt.node_name

  name        = "k8s-ctrl-01"
  description = "Kubernetes Control Plane 01"
  tags        = ["k8s", "control-plane"]
  on_boot     = true
  vm_id       = 9001

#Q35 provides a virtual PCIe bus which allows us to pass through PCIe devices.
  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"
  bios          = "ovmf"

  cpu {
    cores = 4
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 4096
  }

  network_device {
    bridge      = "vmbr0"
    mac_address = "BC:24:11:2E:C0:01"
  }
#datastore_id = proxmox storage pool
  efi_disk {
    datastore_id = "Virt-Pool-SSD"
    file_format  = "raw" // To support qcow2 format
    type         = "4m"
  }

#datastore_id = proxmox storage pool
  disk {
    datastore_id = "Virt-Pool-SSD"
    file_id      = proxmox_virtual_environment_download_file.debian_12_generic_image.id
    interface    = "scsi0"
    cache        = "writethrough"
    discard      = "on"
    ssd          = true
    size         = 32
  }

  boot_order = ["scsi0"]

  agent {
    enabled = true
  }

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 6.X.
  }

  initialization {
    dns {
      domain  = var.vm_dns.domain
      servers = var.vm_dns.servers
    }
    ip_config {
      ipv4 {
        address = "192.168.255.100/24"
        gateway = "192.168.255.1"
      }
    }

    datastore_id      = "Virt-Pool-SSD"
    user_data_file_id = proxmox_virtual_environment_file.cloud-init-ctrl-01.id
  }
}
#once service up, grab IP
output "ctrl_01_ipv4_address" {
  depends_on = [proxmox_virtual_environment_vm.k8s-ctrl-01]
  value      = proxmox_virtual_environment_vm.k8s-ctrl-01.ipv4_addresses[1][0]
}
#store IP in file
resource "local_file" "ctrl-01-ip" {
  content         = proxmox_virtual_environment_vm.k8s-ctrl-01.ipv4_addresses[1][0]
  filename        = "output/ctrl-01-ip.txt"
  file_permission = "0644"
}
#use Inviction Labs shell-resource to grab the kubeconfig-file
module "kube-config" {
  depends_on   = [local_file.ctrl-01-ip]
  source       = "Invicton-Labs/shell-resource/external"
  version      = "0.4.1"
  command_unix = "ssh -o StrictHostKeyChecking=no ${var.vm_user}@${local_file.ctrl-01-ip.content} cat /home/${var.vm_user}/.kube/config"
}
#store the output of this command
resource "local_file" "kube-config" {
  content         = module.kube-config.stdout
  filename        = "output/config"
  file_permission = "0600"
}
#using the -o StrictHostKeyChecking=no flag for ssh. Generally not recommended.
module "kubeadm-join" {
  depends_on   = [local_file.kube-config]
  source       = "Invicton-Labs/shell-resource/external"
  version      = "0.4.1"
  command_unix = "ssh -o StrictHostKeyChecking=no ${var.vm_user}@${local_file.ctrl-01-ip.content} /usr/bin/kubeadm token create --print-join-command"
}