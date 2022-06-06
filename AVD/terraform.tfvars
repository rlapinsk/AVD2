# Customized the sample values below for your environment and either rename to terraform.tfvars or env.auto.tfvars

deploy_location      = "west europe"
rg_name              = "RG_VDI"
tags_name = {
        App               = "AVD"
        Owner             = "IT"
        Confidentiality   = "Internal"
        CostCenter        = "IT"
        Dept              = "IT"
        Env               = "PROD"
        BusinessImpact    = "Moderate"
        MaintenanceWindow = "Sat:6:00AM-Sat:11:00AM"
        Hostpool = "vdi_hp"
}
rdsh_count = "2"
prefix = "VDITest"

domain_user_upn = "svc_avd"
vm_size = "Standard_D2as_v5"
ou_path = ""
local_admin_username = "avdadmin"
existingVnetName = "vdi_vnet"
existingSubnetName = "vdi_subnet"
existingWVDAppGroupName = "vdiappgr"
existingWVDHostPoolName = "vdi_hp"
existingWVDWorkspaceName = "vdi_workspace"
drainmode = "no"
createWorkspaceAppGroupAsso = "No"
SubscriptionId = "2020d672-be3c-4669-a97d-edc7704c5c17"


