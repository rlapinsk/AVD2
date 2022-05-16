data "azurerm_virtual_network" "myvnet"{
    name = var.vnet_name
    resource_group_name = var.rg_name
    #[10.0.0.0/16]
}

resource "azurerm_virtual_network" "myvnet"{
    name                = data.azurerm_virtual_network.myvnet.name
    location            = var.deploy_location
    resource_group_name = var.rg_name
    adress_space        = data.azurerm_virtual_network.myvnet.adress_space

        subnet{
            name            = var.subnet_name
            address_prefix  = "10.0.1.0/24"
        }
}