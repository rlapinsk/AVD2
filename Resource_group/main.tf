resource "azurerm_resource_group" "rg" {
  
  provider = azurerm
  name     = var.rg_name

  location = var.deploy_location

}