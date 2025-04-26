##########################
# Variable Definitions
##########################

# Variable for Azure Key Vault Name
variable "keyvault_name" {
  description = "The name of the Azure Key Vault"
  type        = string
}

# Variable for Resource Group Name
variable "rg_name" {
  description = "The resource group name"
  type        = string
}

# Variable for Azure Location
variable "location" {
  description = "The Azure location for resources"
  type        = string
}

# Variable for Azure Tenant ID
variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

# Variable for object id for IAM access to Key Vault
variable "my_object_id" {
  description = "Azure AD Object ID of the user (yourself)"
  type        = string
}


variable "UPLOAD_IMAGE_URL" {
  type        = string
  description = "The database host to store in Key Vault"
  sensitive   = true
}

variable "IMAGE_RECOGNITION_URL" {
  type        = string
  description = "The database port to store in Key Vault"
  sensitive   = true
}

variable "PROJ_OPENAI_API_KEY" {
  type        = string
  description = "The OpenAI API key to store in Key Vault"
  sensitive   = true
}

variable "PROJ_AZURE_STORAGE_SAS_URL" {
  type        = string
  description = "The Azure Storage SAS URL to store in Key Vault"
  sensitive   = true
}

variable "PROJ_AZURE_STORAGE_CONTAINER" {
  type        = string
  description = "The Azure Storage Container to store in Key Vault"
  sensitive   = true
}
