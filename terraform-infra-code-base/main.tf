# Resource Group Module
module "resource_group" {
  source   = "./modules/general/resource_group"
  rg_name  = var.rg_name
  location = var.location
}

# Security (Key Vault) Module
module "security" {
  source                = "./modules/security"
  keyvault_name         = var.keyvault_name
  location              = module.resource_group.location
  rg_name               = module.resource_group.rg_name
  tenant_id             = var.tenant_id
  my_object_id          = var.my_object_id
  role_definition_names = var.role_definition_names
  keyvault_sku = var.keyvault_sku
  PROJ_OPENAI_API_KEY        = var.PROJ_OPENAI_API_KEY
  PROJ_AZURE_STORAGE_SAS_URL = module.storage.sas_url
  PROJ_AZURE_STORAGE_CONTAINER = var.storage_container_name
  IMAGE_RECOGNITION_URL      = "https://${module.compute.url_fastapi_https}/image_recognition/" 
  UPLOAD_IMAGE_URL           = "https://${module.compute.url_fastapi_https}/upload_image/"
  fastapi_container_id = module.compute.fastapi_container_id
  streamlit_container_id = module.compute.streamlit_container_id
  tag = var.tag
}




# Storage Module
module "storage" {
  source                  = "./modules/storage"
  location                = module.resource_group.location
  rg_name                 = module.resource_group.rg_name
  storage_account_name    = var.storage_account_name
  storage_container_name  = var.storage_container_name
  storage_account_replication_type = var.storage_account_replication_type
  container_access_type = var.container_access_type
  tag = var.tag
  storage_account_tier = var.storage_account_tier
  container_date = var.container_date
}


# Compute Module
module "compute" {
  source   = "./modules/compute"
  location = module.resource_group.location
  rg_name  = module.resource_group.rg_name
  tag = var.tag
  container_registry_sku = var.container_registry_sku
  container_apps_config = var.container_apps_config
  container_registry_name = var.container_registry_name
  container_app_environment_name = var.container_app_environment_name
  image_config = var.image_config
}




