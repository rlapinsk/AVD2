terraform {
    backend "azurerm" {
        storage_account_name = "avdvditerraformstsa"
        container_name = "avdstandardusersprodvdi"
        key = "avdstandardusersprodvdi.tfstate"
      
    }
}
