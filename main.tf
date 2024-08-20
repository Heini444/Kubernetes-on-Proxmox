# main.tf
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.50.0"
    }
  }
}

provider "proxmox" {
  alias    = "ussvirt"
  endpoint = var.ussvirt.endpoint
  insecure = var.ussvirt.insecure

  api_token = var.ussvirt.api_token
  ssh {
    agent    = true
    username = var.ussvirt_auth.username
  }

  tmp_dir = "/var/tmp"
}
