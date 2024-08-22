# variables.auto.tfvars
ussvirt = {
  node_name = "ussvirt"
  endpoint  = "192.168.0.2" #IP address of the Proxmox node
  insecure  = true #If youve set up a certificate for your Proxmox mode you can instead use a URL backed by the certificate and disable insecure mode. 
}

# After generating the token, add it as <USER>!<TOKEN_NAME>=<TOKEN_SECRET>
ussvirt_auth = {
  username  = "prov-user"
  api_token = "prov-user@pam!<TOKEN_NAME>=<TOKEN_SECRET>"
}
# Set VM nodes DNS
vm_dns = {
  domain  = "."
  servers = ["1.1.1.1", "8.8.8.8"]
}

#cloud-init VMs, user, hashed passsword and ssh-key
vm_user      = "user"
vm_password  = "<hashed password>"
host_pub-key = "<ssh-key>"

k8s-version        = "1.29"
cilium-cli-version = "0.16.4"
