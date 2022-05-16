terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.5.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "2.20.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  feautures {  
  }
  alias = "A"
  subscription_id = "xxxxxxxxx"
}

#provider "azurerm" {
  # Configuration options
#  feautures {     
#  }
#  subscription_id = "xxxxxxxxx"
 # alias = "B"
#}

provider "azuread" {
  # Configuration options
  feautures {
      
  }
  alias = "ad_ten"
}