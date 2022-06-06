# Customized the sample values below for your environment and either rename to terraform.tfvars or env.auto.tfvars

deploy_location      = "East US"
rg_name              = "avd-prd-rg-eastus-001"
tags_name = {
        App               = "AVD"
        Owner             = "IT"
        Confidentiality   = "Internal"
        CostCenter        = "IT"
        Dept              = "IT"
        Env               = "PROD"
        BusinessImpact    = "Moderate"
        MaintenanceWindow = "Sat:6:00AM-Sat:11:00AM"
        Hostpool = "avd-su-prod-hp-eastus-001"
}
rdsh_count = "125"
prefix = "VANTAGEVDISP"

domain_user_upn = "svc_avd"
vm_size = "Standard_D2s_v3"
ou_path = ""
local_admin_username = "avdadmin"
existingVnetName = "avd-vnet-eastus1-001"
existingSubnetName = "App-Internal-AZ2"
existingWVDAppGroupName = "avd-su-prod-hp-eastus-001-ag"
existingWVDHostPoolName = "avd-su-prod-hp-eastus-001"
existingWVDWorkspaceName = "avd-prod-ws-eastus-001"
drainmode = "no"
createWorkspaceAppGroupAsso = "No"
SubscriptionId = "69d9f5bd-e2c2-4d19-addc-12711ae84e20"


