terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.81.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terraform_azure" {
  name     = "terraform_azure"
  location = "West Europe"
}

output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_dns_name
}