output "openshift_url" {
  value = "https://${var.installer_vm_ipv4_address}:8443"
}

output "openshift_master_ip" {
  value = "${var.installer_vm_ipv4_address}"
}