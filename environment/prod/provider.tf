terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.49.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "sonu_rg"
    storage_account_name = "sonustorage2"
    container_name       = "tfstate"
    key                  = "genric.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "e088c65c-826b-4b26-8075-ab650aa85523"
}
