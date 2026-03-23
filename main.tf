terraform {
  required_version = ">= 1.0"
}

# Create Resource Group
module "resource_group" {
  source = "git::https://github.com/your-org/terraform-modules-and-pipelines.git//modules/azure/resource-group?ref=main"

  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Sandbox"
    ManagedBy   = "Terraform"
    OSType      = var.os_type
  }
}

# Create Virtual Network
module "vnet" {
  source = "git::https://github.com/your-org/terraform-modules-and-pipelines.git//modules/azure/vnet?ref=main"

  name                = "${var.resource_group_name}-vnet"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  address_space       = var.vnet_address_space

  tags = {
    Environment = "Sandbox"
    ManagedBy   = "Terraform"
  }
}

# Create Subnet
module "subnet" {
  source = "git::https://github.com/your-org/terraform-modules-and-pipelines.git//modules/azure/subnet?ref=main"

  name                 = "${var.resource_group_name}-subnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}

# Create Network Security Group with dynamic rules
module "nsg" {
  source = "git::https://github.com/your-org/terraform-modules-and-pipelines.git//modules/azure/nsg?ref=main"

  name                = "${var.resource_group_name}-nsg"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  security_rules = var.inbound_security_rule

  tags = {
    Environment = "Sandbox"
    ManagedBy   = "Terraform"
  }
}

# Create Public IP
module "public_ip" {
  source = "git::https://github.com/your-org/terraform-modules-and-pipelines.git//modules/azure/public-ip?ref=main"

  name                = "${var.vm_name}-pip"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "Sandbox"
    ManagedBy   = "Terraform"
  }
}

# Create Network Interface
module "nic" {
  source = "git::https://github.com/your-org/terraform-modules-and-pipelines.git//modules/azure/nic?ref=main"

  name                           = "${var.vm_name}-nic"
  resource_group_name            = module.resource_group.name
  location                        = module.resource_group.location
  subnet_id                       = module.subnet.id
  private_ip_allocation_method    = "Dynamic"
  public_ip_address_id            = module.public_ip.id
  network_security_group_id       = module.nsg.id

  tags = {
    Environment = "Sandbox"
    ManagedBy   = "Terraform"
  }
}

# Create VM - Linux or Windows based on os_type
module "vm" {
  source = var.os_type == "linux" ? "git::https://github.com/your-org/terraform-modules-and-pipelines.git//modules/azure/linux-vm?ref=main" : "git::https://github.com/your-org/terraform-modules-and-pipelines.git//modules/azure/windows-vm?ref=main"

  name                = var.vm_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  vm_size             = var.vm_size

  network_interface_ids = [module.nic.id]

  # Admin credentials
  admin_username = var.admin_username
  admin_password = var.admin_password

  # OS-specific configurations
  os_type = var.os_type

  # Source image - use provided or let module use defaults
  publisher = var.source_image != null ? var.source_image.publisher : null
  offer     = var.source_image != null ? var.source_image.offer : null
  sku       = var.source_image != null ? var.source_image.sku : null
  version   = var.source_image != null ? var.source_image.version : null

  tags = {
    Environment = "Sandbox"
    ManagedBy   = "Terraform"
    OSType      = var.os_type
  }

  depends_on = [module.nic]
}
