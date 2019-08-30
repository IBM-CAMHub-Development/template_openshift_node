#New Node
variable "node_hostname_ip" {
  type = "map"
}

variable "node_vcpu" {
  type    = "string"
}

variable "node_memory" {
  type    = "string"
}

variable "node_vm_ipv4_gateway" {
  type = "string"
}

variable "node_vm_ipv4_prefix_length" {
  type = "string"
}

variable "node_vm_disk1_size" {
  type = "string"
}

variable "node_vm_disk1_keep_on_remove" {
  type = "string"
}

variable "node_vm_disk2_enable" {
  type = "string"
}

variable "node_vm_disk2_size" {
  type = "string"
}

variable "node_vm_disk2_keep_on_remove" {
  type = "string"
}

# VM Generic Items
variable "vm_domain" {
  type = "string"
}

variable "vm_network_interface_label" {
  type = "string"
}

variable "vm_adapter_type" {
  type    = "string"
}

variable "vm_folder" {
  type = "string"
}

variable "vm_dns_servers" {
  type = "list"
}

variable "vm_dns_suffixes" {
  type = "list"
}

variable "vm_clone_timeout" {
  description = "The timeout, in minutes, to wait for the virtual machine clone to complete."
}

variable "vsphere_datacenter" {
  type = "string"
}

variable "vsphere_resource_pool" {
  type = "string"
}

variable "vm_template" {
  type = "string"
}

variable "vm_os_user" {
  type = "string"
}

variable "vm_os_password" {
  type = "string"
}

variable "vm_disk1_datastore" {
  type = "string"
}

variable "vm_disk2_datastore" {
  type = "string"
}

# SSH KEY Information
variable "os_private_ssh_key" {
  type = "string"
}

variable "os_public_ssh_key" {
  type = "string"
}

variable "rh_user" {
  type = "string"
}

variable "rh_password" {
  type = "string"
}

variable "installer_vm_ipv4_address" {
  type = "string"
}

variable "node_enable_glusterFS" {
  type = "string"
}