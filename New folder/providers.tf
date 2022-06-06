terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.2"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

provider "azurerm" {
  subscription_id = "69d9f5bd-e2c2-4d19-addc-12711ae84e20"
#Configuration options
  features {}
  
}
provider "azurerm" {
alias = "prod_la"
subscription_id = "02c90d15-7631-49b1-aca5-71f0a191f355"

#Configuration options
  features {}
  
}

