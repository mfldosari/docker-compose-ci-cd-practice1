#################################
# Terraform Provider Configuration
#################################
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.64.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}

#################################
# Azure Container Registry
#################################
resource "azurerm_container_registry" "this" {
  name                = var.container_registry_name
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = var.container_registry_sku
  admin_enabled       = true

  tags = {
    managed_by = var.tag
  }
}

#################################
# Docker Provider Configuration
#################################
provider "docker" {
  host = "unix:///var/run/docker.sock"

  # Authenticate Docker to Azure Container Registry
  registry_auth {
    address  = azurerm_container_registry.this.login_server
    username = azurerm_container_registry.this.admin_username
    password = azurerm_container_registry.this.admin_password
  }
}

#################################
# Build and Push FastAPI Docker Image
#################################
resource "docker_image" "fastapi_image" {
  name = "${azurerm_container_registry.this.login_server}/${var.image_config[0].image_name}:${var.image_config[0].version}"

  build {
    path = var.image_config[0].path
  }
}

resource "docker_registry_image" "fastapi_image_push" {
  name          = docker_image.fastapi_image.name
  keep_remotely = true
}

#################################
# Build and Push Streamlit Docker Image
#################################
resource "docker_image" "streamlit_image" {
  name = "${azurerm_container_registry.this.login_server}/${var.image_config[1].image_name}:${var.image_config[1].version}"

  build {
    path = var.image_config[1].path
  }
}

resource "docker_registry_image" "streamlit_image_push" {
  name          = docker_image.streamlit_image.name
  keep_remotely = true
}

#################################
# Create Container Apps Environment
#################################
resource "azurerm_container_app_environment" "this" {
  name                = var.container_app_environment_name
  location            = var.location
  resource_group_name = var.rg_name

  tags = {
    managed_by = var.tag
  }
}

#################################
# Deploy FastAPI Container App
#################################
resource "azurerm_container_app" "fastapi_app" {
  name                         = var.container_apps_config[0].name
  resource_group_name          = var.rg_name
  container_app_environment_id = azurerm_container_app_environment.this.id
  revision_mode                = var.container_apps_config[0].revision_mode

  template {
    container {
      name   = var.container_apps_config[0].name
      image  = docker_registry_image.fastapi_image_push.name
      cpu    = var.container_apps_config[0].cpu
      memory = var.container_apps_config[0].memory
    }
  }

  # Enable Managed Identity
  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled           = true
    target_port                = var.container_apps_config[0].target_port
    transport                  = var.container_apps_config[0].transport
    allow_insecure_connections = false

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  # Store ACR password as secret
  secret {
    name  = var.container_apps_config[0].secret_name
    value = azurerm_container_registry.this.admin_password
  }

  # Configure registry using the stored secret
  registry {
    server               = azurerm_container_registry.this.login_server        
    username             = azurerm_container_registry.this.admin_username 
    password_secret_name = var.container_apps_config[0].secret_name
  }

  tags = {
    managed_by = var.tag
  }

  depends_on = [
    azurerm_container_app_environment.this
  ]
}

#################################
# Deploy Streamlit Container App
#################################
resource "azurerm_container_app" "streamlit_app" {
  name                         = var.container_apps_config[1].name
  resource_group_name          = var.rg_name
  container_app_environment_id = azurerm_container_app_environment.this.id
  revision_mode                = var.container_apps_config[1].revision_mode

  template {
    container {
      name   = var.container_apps_config[1].name
      image  = docker_registry_image.streamlit_image_push.name
      cpu    = var.container_apps_config[1].cpu
      memory = var.container_apps_config[1].memory
    }
  }

  # Enable Managed Identity
  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled           = true
    target_port                = var.container_apps_config[1].target_port
    transport                  = var.container_apps_config[1].transport
    allow_insecure_connections = false

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  # Store ACR password as secret
  secret {
    name  = var.container_apps_config[1].secret_name
    value = azurerm_container_registry.this.admin_password
  }

  # Configure registry using the stored secret
  registry {
    server               = azurerm_container_registry.this.login_server        
    username             = azurerm_container_registry.this.admin_username 
    password_secret_name = var.container_apps_config[1].secret_name  
  }

  tags = {
    managed_by = var.tag
  }

  depends_on = [
    azurerm_container_app_environment.this
  ]
}
