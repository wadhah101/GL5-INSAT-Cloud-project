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

module "postgresql" {
  source  = "claranet/db-postgresql/azurerm"
  version = "6.0.0"

  postgresql_version = "11"

  client_name    = var.client
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  create_databases_users = false

  public_network_access_enabled = true

  resource_group_name = var.resource_group_name

  tier     = "GeneralPurpose"
  capacity = 2

  allowed_cidrs = {
    "1" = "10.0.0.0/24"
  }

  storage_mb                   = 5120
  backup_retention_days        = 10
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false
  administrator_login          = "admininsat"
  administrator_password       = "notsecurepassword123@123"

  force_ssl = true

  databases_names     = ["maindb"]
  databases_collation = { mydatabase = "en-US" }
  databases_charset   = { mydatabase = "UTF8" }


  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id
  ]
}


