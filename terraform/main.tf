module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "6.1.0"

  azure_region = var.location
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.2.0"
  suffix  = [var.client, module.azure_region.location_short, var.environment, var.stack]
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "6.1.0"


  location    = module.azure_region.location
  client_name = var.client
  environment = var.environment
  stack       = var.stack

  extra_tags = local.extra_tags
}

module "policy" {
  source = "./governance"
}
