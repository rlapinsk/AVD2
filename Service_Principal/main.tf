resource "azuread_application" "avd_sp" {
  display_name = "avd-sp-app"
}

resource "azuread_service_principal" "avd_spn" {
  application_id = azuread_application.avd_sp.application_id
}

resource "azuread_service_principal_password" "avd_spn_pswd" {
  service_principal_id = azuread_service_principal.avd_spn.id
}

data "azurerm_subscription" "primary" {
}

resource "azurerm_role_assignment" "example" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.avd_spn.object_id
}