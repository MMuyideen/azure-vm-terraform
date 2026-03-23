variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "os_type" {
  description = "Operating system type for the VM"
  type        = string
  default     = "linux"

  validation {
    condition     = contains(["linux", "windows"], lower(var.os_type))
    error_message = "os_type must be either 'linux' or 'windows'."
  }
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "sandbox-vm"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "vm-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "UK South"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2ms"
}

variable "admin_username" {
  description = "Username for VM administrator account"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Password for VM administrator account"
  type        = string
  sensitive   = true
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "inbound_security_rule" {
  description = "List of inbound security rules for the NSG"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))

  default = [
    {
      name                       = "AllowSSHLinux"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "AllowRDPWindows"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

variable "source_image" {
  description = "Source image configuration for the VM (publisher, offer, sku, version). If null, module defaults will be used."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}
