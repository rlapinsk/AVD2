data "azurerm_subnet" "subnet" {
  name = var.existingSubnetName
  virtual_network_name = var.existingVnetName
  resource_group_name = var.rg_name
}

resource "azurerm_network_interface" "avd_vm_nic" {
  count               = var.rdsh_count
  name                = "${var.prefix}${format("%03d", count.index + 1)}-nic"
  resource_group_name = var.rg_name
  location            = var.deploy_location
  enable_accelerated_networking   = true
  tags = var.tags_name

  ip_configuration {
    name                          = "nic${count.index + 1}_config"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

     timeouts {
    create = "2h"
    delete = "2h"
  }

}

resource "azurerm_windows_virtual_machine" "avd_vm" {
  count                 = var.rdsh_count
  name                  = "${var.prefix}${format("%03d", count.index + 1)}"
  resource_group_name   = var.rg_name
  location              = var.deploy_location
  size                  = var.vm_size
  network_interface_ids = ["${azurerm_network_interface.avd_vm_nic.*.id[count.index]}"]
  provision_vm_agent    = true
  admin_username        = var.local_admin_username
  admin_password        = var.local_admin_password
  tags = var.tags_name
  timezone = "Eastern Standard Time"
  zone = "2"
allow_extension_operations = true

identity {
  type="SystemAssigned"
}
  os_disk {
    name                 = "${lower(var.prefix)}${format("%03d", count.index + 1)}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"

  }

#source_image_id = "/subscriptions/7494be1d-2d6b-40e5-8f9e-0c04ab877f51/resourceGroups/rg-ib-ue1-arb-pci-avd-vdc/providers/Microsoft.Compute/galleries/sigibue1arbpciavdpew10/images/IMDWIN10EG120H2P0322_3/versions/0.25136.60424"
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-21h2-avd"
    version   = "latest"
  }
  encryption_at_host_enabled = true
  depends_on = [
    azurerm_network_interface.avd_vm_nic
  ]

   timeouts {
    create = "3h"
    delete = "2h"
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      source_image_reference,
    ]
  }

}

# Install dependency agent and MMA agent
resource "azurerm_virtual_machine_extension" "monitor-DependencyAgent-agent" {
  
  count                = var.rdsh_count
  name                 = "${var.prefix}${format("%03d", count.index + 1)}-avd_dependencyagent"
  virtual_machine_id   = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher             = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                  = "DependencyAgentWindows"
  type_handler_version  = "9.5"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled = true
  depends_on = [azurerm_windows_virtual_machine.avd_vm
                  ]
  settings = <<SETTINGS
        {
          "workspaceId": "${data.azurerm_log_analytics_workspace.lg_workspace.workspace_id}"
        }
SETTINGS
 
  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "FVp7N08Q7KDcTGgLlOWwkIe3Gs3xtN6WYKz0XfVAbsAmiYJEt5nhAQ0X9OwFFriYKkP4WVat1KMuPNcD2ltXZA=="
        }
PROTECTED_SETTINGS
 
  tags = var.tags_name

   timeouts {
    create = "2h"
    delete = "2h"
  }

}

#Qualys
/*resource "azurerm_security_center_server_vulnerability_assessment" "avd_qualys" {
 count                = var.rdsh_count
  virtual_machine_id   = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  depends_on = [
    azurerm_windows_virtual_machine.avd_vm,
    azurerm_virtual_machine_extension.monitor-DependencyAgent-agent
  ]


   timeouts {
    create = "2h"
    delete = "2h"
  }

}*/

 data "azurerm_log_analytics_workspace" "lg_workspace" {
   provider = azurerm.prod_la
   resource_group_name = "logs-lz-rg-eastus-001"
   name = "logs-lz-la-eastus-001"

 }

resource "azurerm_virtual_machine_extension" "monitor-agent" {
  count                = var.rdsh_count
  name                 = "${var.prefix}${format("%03d", count.index + 1)}-avd_MMA"
  virtual_machine_id   = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher             = "Microsoft.EnterpriseCloud.Monitoring"
  type                  = "MicrosoftMonitoringAgent"
  type_handler_version  = "1.0"
  auto_upgrade_minor_version = true
  depends_on = [azurerm_windows_virtual_machine.avd_vm,
    azurerm_virtual_machine_extension.monitor-DependencyAgent-agent#,
    #azurerm_security_center_server_vulnerability_assessment.avd_qualys
    ]
  settings = <<SETTINGS
        {
          "workspaceId": "${data.azurerm_log_analytics_workspace.lg_workspace.workspace_id}"
        }
SETTINGS
 
  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "FVp7N08Q7KDcTGgLlOWwkIe3Gs3xtN6WYKz0XfVAbsAmiYJEt5nhAQ0X9OwFFriYKkP4WVat1KMuPNcD2ltXZA=="
        }
PROTECTED_SETTINGS
 
  tags = var.tags_name

   timeouts {
    create = "2h"
    delete = "2h"
  }


}


data "azurerm_subscription" "primary" {}

data "azurerm_role_definition" "custom_byname" {
  name = "Deallocate VM on logoff"
   scope = data.azurerm_subscription.primary.id
}

resource "azurerm_role_assignment" "my_role_assignment" {
  count                      = var.rdsh_count
  scope              = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  role_definition_id = data.azurerm_role_definition.custom_byname.id
  principal_id       = azurerm_windows_virtual_machine.avd_vm[count.index].identity.0.principal_id

 

}

# Wait for reboot to complete after domain join
/*resource "time_sleep" "wait_30_seconds" {
  count = var.rdsh_count
  depends_on = [
        azurerm_virtual_machine_extension.monitor-agent,
azurerm_virtual_machine_extension.domain_join]

  create_duration = "300s"
}*/

# Install Azure Monitoring Agent
resource "azurerm_virtual_machine_extension" "avd_AMA" {
 count                = var.rdsh_count
  name                 = "${var.prefix}${format("%03d", count.index + 1)}-avd_AMA"
  virtual_machine_id   = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher            = "Microsoft.Azure.Monitor"
  type                 = "AzureMonitorWindowsAgent"
  type_handler_version = "1.0"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled = true
 depends_on = [
   azurerm_virtual_machine_extension.monitor-agent#,
  # time_sleep.wait_30_seconds
 ]
  settings = <<SETTINGS
    {
        "workspaceId": "${data.azurerm_log_analytics_workspace.lg_workspace.workspace_id}"
    }
SETTINGS

    protected_settings = <<PROTECTEDSETTINGS
    {
        "workspaceKey": "${var.workspaceKey}"
    }
PROTECTEDSETTINGS
  tags = var.tags_name

   timeouts {
    create = "2h"
    delete = "2h"
  }

}


# Use customscriptextension for installing AVD agent and joining to hostpool
resource "azurerm_virtual_machine_extension" "avd_script" {
  count                = var.rdsh_count
  name                 = "${var.prefix}${format("%03d", count.index + 1)}-avd_script"
  virtual_machine_id   = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  auto_upgrade_minor_version = true
  depends_on = [
        #time_sleep.wait_30_seconds,
         azurerm_virtual_machine_extension.avd_AMA
  ]
  settings = <<SETTINGS
    {
      "fileUris": [
      "https://avdvditerraformstsa.blob.core.windows.net/psscript/Add-WVDHostToHostpoolSpringORG4T.ps1?sp=r&st=2022-03-30T17:31:59Z&se=2024-03-25T01:31:59Z&spr=https&sv=2020-08-04&sr=b&sig=5rmZKMI%2FmDer4DdVbIuy47LTE8XD6yALYqa0at6tnJ8%3D"
      ]
    }
SETTINGS

protected_settings = <<PROTECTED_SETTINGS
    {
"commandToExecute": "powershell.exe -executionpolicy Unrestricted -File \"./Add-WVDHostToHostpoolSpringORG4T.ps1\" ${var.existingWVDWorkspaceName} ${var.existingWVDHostPoolName} ${var.existingWVDAppGroupName} ${var.spn-client-id} ${var.spn-client-secret} ${var.spn-tenant-id} ${var.rg_name} ${var.SubscriptionId} ${var.drainmode} ${var.createWorkspaceAppGroupAsso}"
    }
  PROTECTED_SETTINGS


  tags = var.tags_name

    timeouts {
    create = "2h"
    delete = "2h"
  }
  
 }

 resource "azurerm_virtual_machine_extension" "domain_join" {
  count                      = var.rdsh_count
  name                       = "${var.prefix}${format("%03d", count.index + 1)}-domainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.*.id[count.index]
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
    settings                   = <<-SETTINGS
    {
      "mdmId": "0000000a-0000-0000-c000-000000000000"
    }
    SETTINGS
lifecycle {
   ignore_changes = [
     settings,
   ]
}
  
  depends_on = [
    azurerm_virtual_machine_extension.avd_script
  ]
}





