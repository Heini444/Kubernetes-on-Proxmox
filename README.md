# Kubernetes-on-Proxmox
```
Proxmox 8.x
```
Debian 12 -  Talos maybe later
```
OpenTofu (Terraform) - https://opentofu.org/docs/intro/install/deb/
```
Terraform Provider for Proxmox - https://github.com/bpg/terraform-provider-proxmox
```
Cloud-init & PXE - https://cloudinit.readthedocs.io/
```
Kubeadm - https://kubernetes.io/docs/reference/setup-tools/kubeadm/
```
Cilium - https://cilium.io/
```
VM PCI passthrough - https://pve.proxmox.com/wiki/PCI%28e%29_Passthrough
```
#Create new user on proxmox for provisioning, ref terraform article
https://registry.terraform.io/providers/Telmate/proxmox/latest/docs#creating-the-proxmox-user-and-role-for-terraform
#create ssh key for cloud-init vm user
ssh-keygen -t ed25519 -C "<EMAIL>"
#create a password for use with sudo. don’t provide a clear-text password, but a hashed version.
mkpasswd
docker run -it --rm alpine mkpasswd --method=SHA-512 <PASSWORD>
**#Tofu - Installing using the installer**
```
# Download the installer script:
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
```
# Alternatively: wget --secure-protocol=TLSv1_2 --https-only https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh

# Give it execution permissions:
chmod +x install-opentofu.sh

# Please inspect the downloaded script

# Run the installer:
./install-opentofu.sh --install-method deb

# Remove the installer:
rm -f install-opentofu.sh
```
