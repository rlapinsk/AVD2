resource "azurerm_virtual_network" "myvnet"{
    name                = var.vnet_name
    location            = var.deploy_location
    resource_group_name = var.rg_name
    #adress_space        = [10.0.0.0/16]

}