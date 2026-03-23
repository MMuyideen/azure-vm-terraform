terraform {
  backend "azurerm" {
    resource_group_name  = "deenterraformstate"
    storage_account_name = "deenterraformstate"
    container_name       = "tfstate"
    key                  = "vm.tfstate"
  }
}
