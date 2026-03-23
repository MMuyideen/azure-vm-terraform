output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = module.public_ip.ip_address
}

output "vm_name" {
  description = "Name of the created virtual machine"
  value       = module.vm.vm_name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.resource_group.name
}

output "ssh_command" {
  description = "SSH command to connect to the Linux VM (only applicable for Linux VMs)"
  value       = var.os_type == "linux" ? "ssh -i <your-key> ${var.admin_username}@${module.public_ip.ip_address}" : null
}

output "rdp_info" {
  description = "RDP connection information for Windows VMs (only applicable for Windows VMs)"
  value = var.os_type == "windows" ? {
    host     = module.public_ip.ip_address
    username = var.admin_username
    note     = "Use RDP client to connect to ${module.public_ip.ip_address} with username ${var.admin_username}"
  } : null
}

output "private_ip" {
  description = "Private IP address of the virtual machine"
  value       = module.nic.private_ip_address
}

output "vm_id" {
  description = "ID of the created virtual machine"
  value       = module.vm.vm_id
}
