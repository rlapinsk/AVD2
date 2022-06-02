data "azuread_client_config" "current" {}


resource "azuread_group" "AVD_Admin" {
  display_name     = "AVD Admin"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  provider = azuread.ad_ten

}

resource "azuread_group" "AVD_User" {
  display_name     = "AVD User"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  provider = azuread.ad_ten
}

data "azurerm_resource_group" "primary" {
  name = var.rg_name
}

resource "azurerm_role_assignment" "example1" {
  scope                = data.azurerm_resource_group.primary.id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = azuread_group.AVD_Admin.object_id
}

resource "azurerm_role_assignment" "example2" {
  scope                = data.azurerm_resource_group.primary.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = azuread_group.AVD_User.object_id
}

