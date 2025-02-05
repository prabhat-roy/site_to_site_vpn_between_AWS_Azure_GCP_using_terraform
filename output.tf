output "aws-ec2-public-ip" {
  value = aws_instance.aws-server[*].public_ip
}

output "aws-ec2-private-ip" {
  value = aws_instance.aws-server[*].private_ip
}

output "azure-vm-public-ip" {
  value = azurerm_public_ip.vm_public_ip.ip_address
}

output "azure-vm-private-ip" {
  value = azurerm_network_interface.nic.private_ip_address
}

output "gcp-vm-public-ip" {
  value = google_compute_address.vm.address
}

output "gcp-vm-private-ip" {
  value = google_compute_instance.vm.network_interface.0.network_ip

}