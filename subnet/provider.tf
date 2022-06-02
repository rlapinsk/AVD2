terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.5.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = ">2.20.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = "2020d672-be3c-4669-a97d-edc7704c5c17"
  features {
    
  }
}

#provider "azurerm" {
  # Configuration options
#  features {   
#  }
#  subscription_id = "2020d672-be3c-4669-a97d-edc7704c5c17"
##  alias = "B"
#}

provider "azuread" {
  # Configuration options
  alias = "ad_ten"
}