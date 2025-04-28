##########################
# General Variables
##########################

# Variable for the Resource Group Name
variable "rg_name" {
  description = "The name of the resource group"
  type        = string
}

# Tag for resource management
variable "tag" {}

# Variable for Azure region (location) where resources will be deployed
variable "location" {
  description = "The location where resources will be deployed"
  type        = string
}

# Variable for the storage account tier (e.g., Standard, Premium)
variable "storage_account_tier" {}

# Variable for the storage account replication type (e.g., LRS, ZRS)
variable "storage_account_replication_type" {}

# Variable for the container access type (e.g., private, public)
variable "container_access_type" {}

# Variable for the container's date range (e.g., start and end dates for SAS token)
variable "container_date" {}

##########################
# Storage Variables
##########################

# Variable for the storage account's name
variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

# Variable for the storage container's name
variable "storage_container_name" {
  description = "The name of the storage container"
  type        = string
}
