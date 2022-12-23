module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "7.2.0"

  client_name         = var.client
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = var.resource_group_name
}

resource "azurerm_postgresql_server" "server" {
  name                = module.naming.postgresql_server.name
  location            = module.azure_region.location
  resource_group_name = var.resource_group_name

  sku_name = "B_Gen5_2"

  public_network_access_enabled = true

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"

  administrator_login          = "psqladmin"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "11"
  ssl_enforcement_enabled      = false
}

resource "azurerm_postgresql_database" "database" {
  name                = "exampledb"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

output "vm_ip" {
  value = azurerm_postgresql_server.server.fqdn
}
