provider "vsphere" {
  version              = "~> 1.3"
  allow_unverified_ssl = "true"
}

provider "random" {
  version = "~> 1.0"
}

provider "local" {
  version = "~> 1.1"
}

provider "null" {
  version = "~> 1.0"
}

provider "tls" {
  version = "~> 1.0"
}

resource "random_string" "random-dir" {
  length  = 8
  special = false
}

resource "tls_private_key" "generate" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "null_resource" "create-temp-random-dir" {
  provisioner "local-exec" {
    command = "${format("mkdir -p  /tmp/%s" , "${random_string.random-dir.result}")}"
  }
}

module "deployVM_node" {
  source = "git::https://github.com/IBM-CAMHub-Open/template_openshift_modules.git?ref=3.11//vmware_provision"

  #######
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"

  # count                 = "${length(var.node_vm_ipv4_address)}"
  count = "${length(keys(var.node_hostname_ip))}"

  #######
  // vm_folder = "${module.createFolder.folderPath}"
  enable_vm                  = "true"
  vm_vcpu                    = "${var.node_vcpu}"                                                                                                           // vm_number_of_vcpu
  vm_name                    = "${keys(var.node_hostname_ip)}"
  vm_memory                  = "${var.node_memory}"
  vm_template                = "${var.vm_template}"
  vm_os_password             = "${var.vm_os_password}"
  vm_os_user                 = "${var.vm_os_user}"
  vm_domain                  = "${var.vm_domain}"
  vm_folder                  = "${var.vm_folder}"
  vm_private_ssh_key         = "${length(var.os_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${base64decode(var.os_private_ssh_key)}"}"
  vm_public_ssh_key          = "${length(var.os_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.os_public_ssh_key}"}"
  vm_network_interface_label = "${var.vm_network_interface_label}"
  vm_ipv4_gateway            = "${var.node_vm_ipv4_gateway}"
  # vm_ipv4_address            = "${var.node_vm_ipv4_address}"
  vm_ipv4_address         = "${values(var.node_hostname_ip)}"
  vm_ipv4_prefix_length   = "${var.node_vm_ipv4_prefix_length}"
  vm_adapter_type         = "${var.vm_adapter_type}"
  vm_disk1_size           = "${var.node_vm_disk1_size}"
  vm_disk1_datastore      = "${var.vm_disk1_datastore}"
  vm_disk1_keep_on_remove = "${var.node_vm_disk1_keep_on_remove}"
  vm_disk2_enable         = "${var.node_enable_glusterFS}"
  vm_disk2_size           = "${var.node_vm_disk2_size}"
  vm_disk2_datastore      = "${var.vm_disk2_datastore}"
  vm_disk2_keep_on_remove = "${var.node_vm_disk2_keep_on_remove}"
  vm_dns_servers          = "${var.vm_dns_servers}"
  vm_dns_suffixes         = "${var.vm_dns_suffixes}"
  vm_clone_timeout        = "${var.vm_clone_timeout}"
  random                  = "${random_string.random-dir.result}"

  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}"    
}

module "host_prepare" {
  source = "git::https://github.com/IBM-CAMHub-Open/template_openshift_modules.git?ref=3.11//host_prepare"
  
  private_key          = "${length(var.os_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.os_private_ssh_key)}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  rh_user              = "${var.rh_user}"
  rh_password          = "${var.rh_password}"
  vm_ipv4_address_list = "${values(var.node_hostname_ip)}"
  vm_hostname_list     = "${join(",", keys(var.node_hostname_ip))}"
  domain_name          = "${var.vm_domain}"
  installer_hostname   = "none"
  compute_hostname     = "none"
  random               = "${random_string.random-dir.result}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}"      
  dependsOn           = "${module.deployVM_node.dependsOn}"
}

module "scale_node" {
  source               = "git::https://github.com/IBM-CAMHub-Open/template_openshift_modules.git?ref=3.11//scale_node_template"
  
  private_key          = "${length(var.os_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.os_private_ssh_key)}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  installer_vm_ipv4_address     = "${var.installer_vm_ipv4_address}"
  node_vm_hostname        = "${keys(var.node_hostname_ip)}"
  # node_vm_ipv4_address    = "${values(var.node_hostname_ip)}"
  domain_name                = "${var.vm_domain}"

  random              = "${random_string.random-dir.result}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}"      
  dependsOn           = "${module.host_prepare.dependsOn}"
}