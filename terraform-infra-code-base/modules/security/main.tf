##########################
# Key Vault Resource
##########################

resource "azurerm_key_vault" "kv" {
  # Basic Information for Key Vault
  name                        = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.rg_name
  tenant_id                   = var.tenant_id
  
  # SKU and Access Configuration
  sku_name                    = var.keyvault_sku 
  enable_rbac_authorization   = true

  # Soft Delete and Purge Protection settings
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  
  # Network Access Configuration (enables public access)
  public_network_access_enabled = true  

  # Tags for management and categorization
  tags = {
    managed_by = var.tag
  }

  lifecycle {
    # Prevent the Key Vault from being destroyed
    prevent_destroy = true
  }
}

##########################
# IAM Role Assignment (Self) and Containers
##########################

# Assign the Key Vault Administrator role to the user (self)
resource "azurerm_role_assignment" "kv_admin" {
  principal_id         = var.my_object_id
  role_definition_name = var.role_definition_names[0]
  scope                = azurerm_key_vault.kv.id
}

# Storing the IMAGE_RECOGNITION_URL secret in Key Vault
resource "azurerm_key_vault_secret" "IMAGE_RECOGNITION_URL" {
  name         = "IMAGE-RECOGNITION-URL"
  value        = var.IMAGE_RECOGNITION_URL
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

# Storing the UPLOAD_IMAGE_URL secret in Key Vault
resource "azurerm_key_vault_secret" "UPLOAD_IMAGE_URL" {
  name         = "UPLOAD-IMAGE-URL"
  value        = var.UPLOAD_IMAGE_URL
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

# Storing the OpenAI API key secret in Key Vault
resource "azurerm_key_vault_secret" "openai_key" {
  name         = "OPENAI-API-KEY"
  value        = var.PROJ_OPENAI_API_KEY
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

# Storing the Azure Storage SAS URL in Key Vault
resource "azurerm_key_vault_secret" "sas_url" {
  name         = "AZURE-STORAGE-SAS-URL"
  value        = var.PROJ_AZURE_STORAGE_SAS_URL
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

# Storing the Azure Storage Container name in Key Vault
resource "azurerm_key_vault_secret" "container_name" {
  name         = "AZURE-STORAGE-CONTAINER"
  value        = var.PROJ_AZURE_STORAGE_CONTAINER
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

# Assign Key Vault Secret User role to FastAPI container for accessing Key Vault
resource "azurerm_role_assignment" "fastapi_keyvault_access" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = var.role_definition_names[1]
  principal_id         = var.fastapi_container_id 
}

# Assign Key Vault Secret User role to Streamlit container for accessing Key Vault
resource "azurerm_role_assignment" "streamlit_keyvault_access" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = var.role_definition_names[1]
  principal_id         = var.streamlit_container_id 
}
