# variables.tf
variable "ussvirt" {
  description = "ussvirt Proxmox server configuration"
  type        = object({
    node_name = string
    endpoint  = string
    insecure  = bool
  })
}

#create a separate user with only the necessary privileges in proxmox
variable "ussvirt_auth" {
  description = "ussvirt Proxmox server auth"
  type        = object({
    username  = string
    api_token = string
  })
  sensitive = true
}

# DNS search domain
variable "vm_dns" {
  description = "DNS config for VMs"
  type = object({
    domain = string
    servers = list(string)
  })
}

# Cloud-init VM user
variable "vm_user" {
  description = "VM username"
  type        = string
}

# Cloud-init VM password
variable "vm_password" {
  description = "VM password"
  type        = string
  sensitive   = true
}

#generated public key
variable "host_pub-key" {
  description = "Host public key"
  type        = string
}

#Kubernetes and Cilium CLI
variable "k8s-version" {
  description = "Kubernetes version"
  type        = string
}

variable "cilium-cli-version" {
  description = "Cilium CLI version"
  type        = string
}
