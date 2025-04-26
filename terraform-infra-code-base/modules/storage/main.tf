
##########################
# Storage Account Configuration
##########################

# Storage Account Resource
resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    made_by = "terraform"
  }
}

# Storage Container Resource
resource "azurerm_storage_container" "this" {
  name                  = var.storage_container_name 
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.this]
}


data "azurerm_storage_account_blob_container_sas" "this" {
  connection_string = azurerm_storage_account.this.primary_connection_string
  container_name    = azurerm_storage_container.this.name

  start  = "2024-01-01"
  expiry = "2030-01-01"

  permissions {
    read   = true
    write  = true
    delete = true
    list   = true
    add    = true
    create = true
  }
}
