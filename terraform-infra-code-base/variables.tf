#################################
# Project Basic Configuration
#################################

# Resource group name
variable "rg_name" {
  description = "The name of the resource group"
  default     = "<enter your resource group name here>"  # Example: my-resource-group
}

# Azure region
variable "location" {
  description = "Azure region for resource deployment"
  default     = "<enter your desired Azure region, e.g., eastus>"  # Example: eastus, westeurope
}

# Tag for resources
variable "tag" {
  description = "Resource tag"
  default     = "<enter your tag, e.g., terraform>"  # Example: project-x, environment-prod
}

#################################
# Azure Subscription Information
#################################

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  default     = "<enter your Azure Tenant ID here>"  # Example: 38609e29-cd43-4866-a729-1297a9b63cad
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "<enter your Azure Subscription ID here>"  # Example: ac2d458e-bde5-440e-86dc-d8312f7cb11a
}

#################################
# Container Registry Configuration
#################################

variable "container_registry_name" {
  description = "Container Registry name"
  default     = "<enter your container registry name here>"  # Example: mycontainerregistry
}

variable "container_registry_sku" {
  description = "Container Registry SKU"
  default     = "<enter your container registry SKU, e.g., Basic>"  # Example: Basic, Premium
}

#################################
# Container Apps Configuration
#################################

variable "container_app_environment_name" {
  description = "Name for the Container Apps environment"
  default     = "<enter your container apps environment name here>"  # Example: my-container-apps-env
}

variable "image_config" {
  description = "Image build configuration"
  type = list(object({
    image_name = string
    version    = string
    path       = string
  }))
  default = [
    { image_name = "<enter image name for app1>", version = "<enter version, e.g., v1>", path = "<enter path to Dockerfile or app>" },  # Example: fastapi-app
    { image_name = "<enter image name for app2>", version = "<enter version, e.g., v1>", path = "<enter path to Dockerfile or app>" },  # Example: streamlit-app
  ]
}

variable "container_apps_config" {
  description = "Container Apps settings"
  type = list(object({
    name          = string
    revision_mode = string
    cpu           = number
    memory        = string
    target_port   = number
    transport     = string
    secret_name   = string
  }))
  default = [
    { name = "<enter container name>", revision_mode = "<enter revision mode, e.g., Single>", cpu = 0.5, memory = "<enter memory, e.g., 1.0Gi>", target_port = 5000, transport = "auto", secret_name = "<enter secret name>" },  # Example: fastapi-app
    { name = "<enter container name>", revision_mode = "<enter revision mode, e.g., Single>", cpu = 0.5, memory = "<enter memory, e.g., 1.0Gi>", target_port = 8501, transport = "auto", secret_name = "<enter secret name>" },  # Example: streamlit-app
  ]
}

#################################
# Key Vault Configuration
#################################

variable "keyvault_name" {
  description = "Azure Key Vault name"
  type        = string
  default     = "<enter key vault name here>"  # Example: my-keyvault
}

variable "keyvault_sku" {
  description = "Azure Key Vault SKU"
  type        = string
  default     = "<enter key vault SKU, e.g., standard>"  # Example: standard, premium
}

variable "role_definition_names" {
  description = "Roles assigned to Key Vault access"
  default     = ["Key Vault Administrator", "Key Vault Secrets User"]  # Example: ["Key Vault Administrator"]
}

variable "my_object_id" {
  description = "Azure AD Object ID for IAM access"
  type        = string
  default     = "<enter your Azure AD Object ID here>"  # Example: f386f33a-9b63-42dd-bf69-9b3e5d3984e9
}

variable "PROJ_OPENAI_API_KEY" {
  description = "The OpenAI API key stored in Key Vault"
  type        = string
  default     = "<enter OpenAI API key here>"  # Example: sk-your-openai-api-key-here
  sensitive   = true
}

#################################
# Storage Account Configuration
#################################

variable "storage_account_name" {
  description = "Storage account name"
  type        = string
  default     = "<enter your storage account name here>"  # Example: mystorageaccount
}

variable "storage_account_tier" {
  description = "Storage account tier"
  default     = "<enter storage account tier, e.g., Standard>"  # Example: Standard, Premium
}

variable "storage_account_replication_type" {
  description = "Replication type for Storage Account"
  default     = "<enter replication type, e.g., LRS>"  # Example: LRS, GRS
}

variable "storage_container_name" {
  description = "Storage container name"
  type        = string
  default     = "<enter your storage container name here>"  # Example: my-container
}

variable "container_access_type" {
  description = "Access type for the storage container"
  default     = "<enter access type, e.g., private>"  # Example: private, blob
}

variable "container_date" {
  description = "Start and end date for container SAS"
  default     = {
    start = "<enter start date, e.g., 2024-01-01>"  # Example: 2024-01-01
    end   = "<enter end date, e.g., 2030-01-01>"    # Example: 2030-01-01
  }
}
