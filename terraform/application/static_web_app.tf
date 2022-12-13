resource "azurerm_static_site" "website" {
  name                = module.naming.app_service.name
  resource_group_name = var.resource_group_name
  location            = "westeurope"
  sku_tier            = "Free"
  sku_size            = "Free"
}
