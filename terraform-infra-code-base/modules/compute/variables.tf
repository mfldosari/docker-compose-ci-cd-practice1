# The resource group name in which the VM will reside
variable "rg_name" {
  description = "The name of the resource group for the VM"
}

# The location of the resources (e.g., "East US", "West Europe")
variable "location" {
  description = "The location of the resources"
}
