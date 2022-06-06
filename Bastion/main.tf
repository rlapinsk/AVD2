
resource "azurerm_public_ip" "example" {
  name                = "examplepip"
  location            = var.deploy_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

data "azurerm_subnet" "BastionSubnet" {
  name = "AzureBastionSubnet"
  resource_group_name = var.rg_name
  virtual_network_name = "vdi_vnet"
}

resource "azurerm_bastion_host" "example" {
  name                = "examplebastion"
  location            = var.deploy_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.BastionSubnet.id
    public_ip_address_id = azurerm_public_ip.example.id
  }
}