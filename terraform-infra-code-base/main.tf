##########################
# Resource Group Module
##########################

module "resource_group" {
  source   = "./modules/general/resource_group"
  rg_name  = var.rg_name
  location = var.location
}

##########################
# Security (Key Vault) Module
##########################

module "security" {
  source            = "./modules/security"
  keyvault_name     = var.keyvault_name
  location          = module.resource_group.location
  rg_name           = module.resource_group.rg_name
  tenant_id         = var.tenant_id
  my_object_id      = var.my_object_id

    # Secrets related to the project
  PROJ_OPENAI_API_KEY = var.PROJ_OPENAI_API_KEY
  PROJ_AZURE_STORAGE_SAS_URL = module.storage.sas_url
  PROJ_AZURE_STORAGE_CONTAINER = var.storage_container_name
  IMAGE_RECOGNITION_URL = var.storage_container_name #fix it later
  UPLOAD_IMAGE_URL  = var.storage_container_name #fix it later
}


##########################
# Storage Module
##########################

module "storage" {
  source               = "./modules/storage"
  location          = module.resource_group.location
  rg_name           = module.resource_group.rg_name
  storage_account_name = var.storage_account_name
  storage_container_name = var.storage_container_name
}