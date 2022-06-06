variable "spn-client-id" {}
variable "spn-client-secret" {}
variable "spn-tenant-id" {}
variable "local_admin_password" {}
#variable "domain_password" {}
variable "rg_name" {
  type        = string
  description = "Name of the Resource group in which to deploy these resources"
}

variable "deploy_location" {
  type        = string
  description = "location"
}
variable "rdsh_count" {
  description = "Number of AVD machines to deploy"
  default     = 2
}

variable "prefix" {
  type        = string
  description = "Prefix of the name of the AVD machine(s)"
}

variable "domain_user_upn" {
  type        = string
  description = "Username for domain join (do not include domain name as this is appended)"
}

variable "vm_size" {
  type = string
  description = "Size of the machine to deploy"
  default     = "Standard_DS2_v2"
}

variable "local_admin_username" {
  type        = string
  description = "local admin username"
}

variable "tags_name" {
  type = map
    description = "Tags for Vantage resources"
}
variable    "existingVnetName"  {
            type = string
                description = "Existing VNET that contains the domain controller"
        }
variable "existingWVDWorkspaceName" {
            type = string
            description = "existingWVDWorkspaceName"
            }
variable  "existingWVDHostPoolName" {
            type = string
            description = "existingWVDHostPoolName"
}
variable "existingWVDAppGroupName" {
        type = string
        description = "existingWVDAppGroupName"
            }
variable  "drainmode" {
            type = string
            description = "drainmode"
            }
variable  "createWorkspaceAppGroupAsso" {
            type = string
            description = "createWorkspaceAppGroupAsso"
            }
variable "existingSubnetName" {
            type = string
                description = "Existing subnet that contains the domain controller"
            }
/*variable "domain_name" {
            type = string
            description = "The FQDN of the AD domain"
            }*/

variable   "ou_path" {
            type = string
            description = "Organizational Unit path in which the nodes and cluster will be present."
            }

/*variable "workspaceId" {
  type = string
  description = "Loganalytics Workspace ID"
}*/

variable "workspaceKey" {
    type = string
  description = "Log Analytics Workspace Key"
  sensitive = true
}
variable SubscriptionId {
    type = string
    description = "Subscription ID for AVD teanant"
}