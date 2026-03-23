# Azure VM Terraform - Unified Linux and Windows

This repository contains a unified Terraform configuration that dynamically creates either Linux or Windows virtual machines on Microsoft Azure. It merges the functionality of the previous `azure-linux-vm-terraform` and `azure-win-vm-terraform` repositories into a single, flexible solution.

## Features

- **Dynamic OS Selection**: Specify `os_type` as either `linux` or `windows` to create the appropriate VM
- **Modular Architecture**: Uses reusable Terraform modules from the `terraform-modules-and-pipelines` repository
- **Infrastructure as Code**: Complete Azure infrastructure including networking, security, and compute resources
- **CI/CD Ready**: GitHub Actions workflow for automated deployments
- **Flexible Security**: Dynamic network security groups with customizable inbound rules
- **State Management**: Remote state storage in Azure backend

## Supported Operating Systems

- **Linux**: Ubuntu 22.04 LTS (customizable via `source_image` variable)
- **Windows**: Windows Server 2022 (customizable via `source_image` variable)

## Prerequisites

1. Azure subscription with appropriate permissions
2. Terraform >= 1.0 installed locally
3. Azure CLI installed and authenticated
4. Git access to `terraform-modules-and-pipelines` repository
5. GitHub repository with appropriate secrets configured (for CI/CD)

## Quick Start

### Local Deployment

1. Clone this repository:
   ```bash
   git clone https://github.com/your-org/azure-vm-terraform.git
   cd azure-vm-terraform
   ```

2. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Edit `terraform.tfvars` with your values:
   ```hcl
   subscription_id      = "your-subscription-id"
   os_type              = "linux"  # or "windows"
   vm_name              = "my-vm"
   admin_password       = "SecurePassword123!"
   # ... other variables
   ```

4. Initialize Terraform:
   ```bash
   terraform init
   ```

5. Review the plan:
   ```bash
   terraform plan
   ```

6. Apply the configuration:
   ```bash
   terraform apply
   ```

### CI/CD Deployment (GitHub Actions)

1. Set up the following GitHub Secrets in your repository:
   - `AZURE_CLIENT_ID`: Service Principal Client ID
   - `AZURE_CLIENT_SECRET`: Service Principal Client Secret
   - `AZURE_TENANT_ID`: Azure Tenant ID
   - `AZURE_SUBSCRIPTION_ID`: Azure Subscription ID
   - `TERRAFORM_RG`: Terraform state resource group name
   - `TERRAFORM_SA`: Terraform state storage account name
   - `VM_ADMIN_PASSWORD`: VM administrator password

2. Trigger the workflow:
   - Push to `main` branch to run a plan
   - Use workflow_dispatch to manually trigger with custom inputs (os_type and action)

## Variables

Key variables:

- `os_type` (required): Either "linux" or "windows"
- `vm_name`: Name of the VM (default: "sandbox-vm")
- `resource_group_name`: Azure resource group name (default: "vm-rg")
- `location`: Azure region (default: "UK South")
- `vm_size`: VM size (default: "Standard_B2ms")
- `admin_username`: Admin user (default: "azureuser")
- `admin_password`: Admin password (required, must be set via secrets in CI/CD)
- `inbound_security_rule`: List of NSG rules with sensible defaults for both OS types
- `source_image`: Custom source image configuration (optional, module defaults used if null)

See `variables.tf` for complete variable definitions.

## Outputs

The configuration provides:

- `vm_public_ip`: Public IP address of the created VM
- `vm_name`: Name of the VM
- `private_ip`: Private IP address of the VM
- `ssh_command`: SSH connection command (Linux only)
- `rdp_info`: RDP connection details (Windows only)
- `resource_group_name`: Name of the resource group
- `vm_id`: Azure resource ID of the VM

## Modules

This configuration uses the following modules from `terraform-modules-and-pipelines`:

- `modules/azure/resource-group`: Creates Azure resource group
- `modules/azure/vnet`: Creates virtual network
- `modules/azure/subnet`: Creates subnet
- `modules/azure/nsg`: Creates network security group
- `modules/azure/public-ip`: Creates public IP address
- `modules/azure/nic`: Creates network interface
- `modules/azure/linux-vm`: Creates Linux virtual machine
- `modules/azure/windows-vm`: Creates Windows virtual machine

## Examples

### Deploy Linux VM

```hcl
# terraform.tfvars
os_type         = "linux"
vm_name         = "linux-server"
admin_username  = "linuxuser"
admin_password  = "P@ssw0rd123!"
```

### Deploy Windows VM

```hcl
# terraform.tfvars
os_type         = "windows"
vm_name         = "windows-server"
admin_username  = "WindowsAdmin"
admin_password  = "P@ssw0rd123!"
```

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

Or via GitHub Actions workflow_dispatch with action set to "destroy".

## Security Considerations

- **Never commit sensitive data**: Do not commit `terraform.tfvars` with passwords to Git
- **Use GitHub Secrets**: Store sensitive values in GitHub Secrets for CI/CD
- **Restrict NSG Rules**: Update `inbound_security_rule` to restrict source IP addresses in production
- **Use Azure Key Vault**: Consider using Azure Key Vault to manage secrets
- **Audit Logging**: Enable audit logs for all infrastructure changes

## Troubleshooting

### Terraform Init Fails with Backend Error

Ensure the Azure storage account and container exist, and Azure CLI is authenticated:

```bash
az login
az account set --subscription <subscription-id>
```

### Module Source Not Found

Verify Git access to `terraform-modules-and-pipelines` repository and that the `ref=main` branch exists.

### NSG Rules Not Applied

Check that the module correctly references `inbound_security_rule` variable and that all required fields are populated.

## Contributing

To contribute to this repository:

1. Create a feature branch
2. Make your changes
3. Run `terraform fmt` to format code
4. Submit a pull request

## License

[Specify your license here]

## Support

For issues or questions, please open an issue in the repository or contact the infrastructure team.
