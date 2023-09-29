# An application gateway for the web service
resource "azurerm_application_gateway" "appgw" {
  name                = "s185-sandbox-appgw"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 3
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Detection"
    rule_set_version = "3.2"
  }

  # A firewall policy
  firewall_policy_id = azurerm_web_application_firewall_policy.fwpol.id

  gateway_ip_configuration {
    name      = "s185-sandbox-gw-ip"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = "s185-sandbox-frontend-port"
    port = 80
  }

  frontend_port {
    name = "s185-sandbox-frontend-ssl-port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "s185-sandbox-frontend-ip"
    public_ip_address_id = azurerm_public_ip.pip1.id
  }

  backend_address_pool {
    name  = "s185-sandbox-backend-pool"
    fqdns = [azurerm_linux_web_app.linux-web-app.default_hostname]
  }

  backend_http_settings {
    name                                = "s185-sandbox-backend-http-settings"
    pick_host_name_from_backend_address = true
    cookie_based_affinity               = "Disabled"
    path                                = "/"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 30
    probe_name                          = "s185-sandbox-probe"
  }

  http_listener {
    name                           = "s185-sandbox-http-listener"
    frontend_ip_configuration_name = "s185-sandbox-frontend-ip"
    frontend_port_name             = "s185-sandbox-frontend-port"
    protocol                       = "Http"
  }

  http_listener {
    name                           = "s185-sandbox-ssl-listener"
    frontend_ip_configuration_name = "s185-sandbox-frontend-ip"
    frontend_port_name             = "s185-sandbox-frontend-ssl-port"
    protocol                       = "Https"
    ssl_certificate_name           = "s185-sandbox-ssl-cert"
  }

  ssl_certificate {
    name = "s185-sandbox-ssl-cert"
    data = filebase64("self-signed.pfx")
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  redirect_configuration {
    name                 = "s185-sandbox-redirect-config"
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = "s185-sandbox-ssl-listener"
  }

  request_routing_rule {
    name                        = "s185-sandbox-redirect-rule"
    rule_type                   = "Basic"
    redirect_configuration_name = "s185-sandbox-redirect-config"
    priority                    = 2001
    http_listener_name          = "s185-sandbox-http-listener"
  }

  probe {
    name                                      = "s185-sandbox-probe"
    pick_host_name_from_backend_http_settings = true
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    protocol                                  = "Http"
  }

  tags = data.azurerm_resource_group.rg.tags
}

# A firewall policy
resource "azurerm_web_application_firewall_policy" "fwpol" {
  name                = "s185-sandbox-fwpol"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }

    managed_rule_set {
      type    = "Microsoft_BotManagerRuleSet"
      version = "0.1"
    }
  }

  policy_settings {
    mode = "Detection"
  }

  tags = data.azurerm_resource_group.rg.tags
}
