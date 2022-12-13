# module "storage_account" {
#   source  = "claranet/storage-account/azurerm"
#   version = "7.3.0"

#   location            = module.azure_region.location
#   location_short      = module.azure_region.location_short
#   client_name         = var.client
#   environment         = var.environment
#   stack               = var.stack
#   resource_group_name = module.rg.resource_group_name

#   account_replication_type = "LRS"
#   logs_destinations_ids    = []

#   extra_tags = local.extra_tags
# }
