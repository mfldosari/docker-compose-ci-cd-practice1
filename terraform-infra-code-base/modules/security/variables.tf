##########################
# Variable Definitions
##########################

# Variable for Azure Key Vault Name
variable "keyvault_name" {
  description = "The name of the Azure Key Vault"
  type        = string
}

# Tag used for resource management
variable "tag" {}

# Variable for Azure Key Vault SKU
variable "keyvault_sku" {
  description = "The SKU of the Azure Key Vault"
  type        = string
}

# Variable for defining IAM roles (e.g., Key Vault access roles)
variable "role_definition_names" {}

# Variable for Resource Group Name where the resources will reside
variable "rg_name" {
  description = "The resource group name"
  type        = string
}

# Variable for Azure location where the resources will be deployed
variable "location" {
  description = "The Azure location for resources"
  type        = string
}

# Variable for Azure Tenant ID used for identity and access management
variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

# Variable for object ID for IAM access to Key Vault (your Azure AD Object ID)
variable "my_object_id" {
  description = "Azure AD Object ID of the user (yourself)"
  type        = string
}

# Variable for the URL to upload images (to be stored in Key Vault)
variable "UPLOAD_IMAGE_URL" {
  type        = string
  description = "The database host to store in Key Vault"
  sensitive   = true
}

# Variable for the URL used for image recognition (to be stored in Key Vault)
variable "IMAGE_RECOGNITION_URL" {
  type        = string
  description = "The database port to store in Key Vault"
  sensitive   = true
}

# Variable for the OpenAI API key to be stored securely in Key Vault
variable "PROJ_OPENAI_API_KEY" {
  type        = string
  description = "The OpenAI API key to store in Key Vault"
  sensitive   = true
}

# Variable for the Azure Storage SAS URL to be stored in Key Vault
variable "PROJ_AZURE_STORAGE_SAS_URL" {
  type        = string
  description = "The Azure Storage SAS URL to store in Key Vault"
  sensitive   = true
}

# Variable for the Azure Storage Container name to be stored in Key Vault
variable "PROJ_AZURE_STORAGE_CONTAINER" {
  type        = string
  description = "The Azure Storage Container to store in Key Vault"
  sensitive   = true
}

# Variable for FastAPI container ID (used for IAM role assignments)
variable "fastapi_container_id" {
  type        = string
  description = "FastAPI container ID"
}

# Variable for Streamlit container ID (used for IAM role assignments)
variable "streamlit_container_id" {
  type        = string
  description = "Streamlit container ID"
}
