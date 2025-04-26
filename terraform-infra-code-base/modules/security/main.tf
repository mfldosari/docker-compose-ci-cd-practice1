##########################
# Key Vault Resource
##########################

resource "azurerm_key_vault" "kv" {
  # Basic Information
  name                        = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.rg_name
  tenant_id                   = var.tenant_id
  
  # SKU and Access Configuration
  sku_name                    = "standard"
  enable_rbac_authorization   = true

  # Soft Delete and Purge Protection
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  
  # Network Access Configuration
  public_network_access_enabled = true  

  # Tags
  tags = {
    managed_by = "terraform"
  }
}



##########################
# IAM Role Assignment (Self) and (VMSS)
##########################

resource "azurerm_role_assignment" "kv_admin" {
  principal_id         = var.my_object_id
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.kv.id
}


resource "azurerm_key_vault_secret" "dbname" {
  name         = "IMAGE-RECOGNITION-URL"
  value        = var.IMAGE_RECOGNITION_URL
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

resource "azurerm_key_vault_secret" "dbuser" {
  name         = "UPLOAD-IMAGE-URL"
  value        = var.UPLOAD_IMAGE_URL
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

resource "azurerm_key_vault_secret" "openai_key" {
  name         = "PROJ-OPENAI-API-KEY"
  value        = var.PROJ_OPENAI_API_KEY
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

resource "azurerm_key_vault_secret" "sas_url" {
  name         = "PROJ-AZURE-STORAGE-SAS-URL"
  value        = var.PROJ_AZURE_STORAGE_SAS_URL
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

resource "azurerm_key_vault_secret" "container_name" {
  name         = "PROJ-AZURE-STORAGE-CONTAINER"
  value        = var.PROJ_AZURE_STORAGE_CONTAINER
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}


