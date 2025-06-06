resource "azurerm_resource_group" "this" {
  name     = var.rg_name
  location = var.location

  tags = {
    manged_by = var.tag
  }
    lifecycle {
    prevent_destroy = true
  }
}