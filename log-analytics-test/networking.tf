resource "azurerm_virtual_network" "vnet1" {
  name                = "s185-sandbox-vnet1"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  tags                = data.azurerm_resource_group.rg.tags
}

# Private subnet for the frontend
resource "azurerm_subnet" "frontend" {
  name                 = "s185-sandbox-frontend"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Private subnet for the backend
resource "azurerm_subnet" "backend" {
  name                                          = "s185-sandbox-backend"
  resource_group_name                           = data.azurerm_resource_group.rg.name
  virtual_network_name                          = azurerm_virtual_network.vnet1.name
  address_prefixes                              = ["10.0.2.0/24"]
  private_link_service_network_policies_enabled = false
}