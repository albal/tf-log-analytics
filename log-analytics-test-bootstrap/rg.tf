resource "azurerm_resource_group" "rg" {
  name     = "s185-sandbox-rg"
  location = "westeurope"
  tags = {
    "Environment"      = "Sandbox"
    "User"             = "Al West"
  }
}
