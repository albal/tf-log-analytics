resource "azurerm_resource_group" "rg" {
  name     = "s185-sandbox-rg"
  location = "westeurope"
  tags = {
    "Environment"      = "Sandbox"
    "Parent Business"  = "Children’s Care"
    "Service Offering" = "Social Workforce"
    "Portfolio"        = "Vulnerable Children and Families"
    "Service Line"     = "Children and Social care"
    "Service"          = "Children and Social care"
    "Product"          = "Social Workforce"
    "User"             = "Al West"
  }
}
