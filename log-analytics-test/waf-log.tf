data "azurerm_log_analytics_workspace" "la-ws" {
  name                = "s185-sandbox-log-analytics-ws"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_monitor_diagnostic_setting" "firewall-diagnostics" {
  name                       = "s185-firewall-diagnostics"
  target_resource_id         = azurerm_application_gateway.appgw.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.la-ws.id

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }

  log {
    category = "ApplicationGatewayAccessLog"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }

  log {
    category = "ApplicationGatewayFirewallLog"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }

  log {
    category = "ApplicationGatewayPerformanceLog"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
}
