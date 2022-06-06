resource "azurerm_storage_account" "storageaccountname" {
  name                     = var.saname
  resource_group_name      = var.rg_name
  location                 = var.deploy_location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "contname" {
  name                  = var.containername
  storage_account_name  = azurerm_storage_account.storageaccountname.name
  container_access_type = "private"
}
