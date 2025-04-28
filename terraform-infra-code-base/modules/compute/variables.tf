#################################
# Resource Group and Location
#################################

# The resource group name in which the VM will reside
variable "rg_name" {
  description = "The name of the resource group for the VM"
}

# The location of the resources (e.g., East US, West Europe)
variable "location" {
  description = "The location of the resources"
}

#################################
# Container Registry Configuration
#################################

# The name of the Azure Container Registry (ACR)
variable "container_registry_name" {
  description = "Container Registry name"
}

# The SKU (pricing tier) for the Azure Container Registry
variable "container_registry_sku" {
  description = "Container Registry sku"
}

#################################
# Tags and Configuration Settings
#################################

# The tag to be applied to resources for categorization or management purposes
variable "tag" {
  description = "Tag for managing resources"
}

#################################
# Docker Image Configuration
#################################

# List of Docker image configurations (name, version, and build path)
variable "image_config" {
  type = list(object({
    image_name = string   # Name of the Docker image (e.g., "fastapi-app")
    version    = string   # Version of the Docker image (e.g., "v1")
    path       = string   # Path to the build directory of the image
  }))
}

#################################
# Container Apps Configuration
#################################

# The name of the Azure Container Apps environment
variable "container_app_environment_name" {
  description = "The name of the Azure Container Apps environment"
}

# List of configurations for each container app (name, revision mode, resources, etc.)
variable "container_apps_config" {
  type = list(object({
    name            = string  # Name of the container app
    revision_mode   = string  # Mode of the revision (e.g., "Single")
    cpu             = number  # Number of CPUs to allocate to the container app
    memory          = string  # Amount of memory to allocate (e.g., "1Gi")
    target_port     = number  # Port for the container app to listen on
    transport       = string  # Transport protocol (e.g., "auto")
    secret_name     = string  # Name of the secret used for registry authentication
  }))
}
