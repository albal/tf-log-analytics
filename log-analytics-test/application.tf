# Definition of a service plan for a Linux Container
resource "azurerm_service_plan" "service-plan" {
  name                = "s185-sandbox-service-plan"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "P1v2"
  tags                = data.azurerm_resource_group.rg.tags
}

# Definition of the linux web app for the service
resource "azurerm_linux_web_app" "linux-web-app" {
  name                = "s185-sandbox-linux-web-app"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.service-plan.id

  app_settings = {
    DOCKER_ENABLE_CI = "true"
  }

  site_config {
    application_stack {
      docker_image     = "nginx"
      docker_image_tag = "latest"
    }
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 31
        retention_in_mb   = 100
      }
    }
  }

  tags = data.azurerm_resource_group.rg.tags
}

resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.linux-web-app.id

  app_settings = {
    DOCKER_ENABLE_CI = "true"
  }

  site_config {
    application_stack {
      docker_image     = "nginx"
      docker_image_tag = "latest"
    }
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 31
        retention_in_mb   = 100
      }
    }
  }

  tags = data.azurerm_resource_group.rg.tags
}
