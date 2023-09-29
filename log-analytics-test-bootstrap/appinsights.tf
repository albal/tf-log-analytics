resource "azurerm_log_analytics_workspace" "log-analytics-ws" {
  name                = "s185-sandbox-log-analytics-ws"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = azurerm_resource_group.rg.tags
}

resource "azurerm_application_insights" "appinsights" {
  name                = "s185-sandbox-appinsights"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  workspace_id        = azurerm_log_analytics_workspace.log-analytics-ws.id
  application_type    = "web"
  tags                = azurerm_resource_group.rg.tags
}

