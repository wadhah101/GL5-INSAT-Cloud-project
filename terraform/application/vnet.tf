resource "random_string" "encrypt" {
  length  = 16
  special = true
}

module "azure_network_vnet" {
  source  = "claranet/vnet/azurerm"
  version = "5.2.0"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client
  stack          = var.stack

  resource_group_name = var.resource_group_name

  vnet_cidr = ["10.0.0.0/16"]
}

data "azurerm_network_watcher" "network_watcher" {
  name                = "NetworkWatcher_${module.azure_region.location_cli}"
  resource_group_name = "NetworkWatcherRG"
}

module "azure_network_security_group" {
  source  = "claranet/nsg/azurerm"
  version = "7.3.0"

  client_name    = var.client
  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  stack          = var.stack

  application_gateway_rules_enabled = true

  network_watcher_name                = data.azurerm_network_watcher.network_watcher.name
  network_watcher_resource_group_name = data.azurerm_network_watcher.network_watcher.resource_group_name

  resource_group_name = var.resource_group_name
}

module "azure_network_route_table" {
  source  = "claranet/route-table/azurerm"
  version = "5.2.0"

  client_name         = var.client
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = var.resource_group_name
}


module "azure_network_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "6.1.0"

  environment    = var.environment
  location_short = module.azure_region.location_short
  client_name    = var.client
  stack          = join("-", [var.stack, "private"])

  resource_group_name = var.resource_group_name

  virtual_network_name = module.azure_network_vnet.virtual_network_name
  subnet_cidr_list     = ["10.0.0.0/24"]
  subnet_delegation = {
    app-service-plan = [
      {
        name    = "Microsoft.ContainerInstance/containerGroups"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    ]
  }

  route_table_name            = module.azure_network_route_table.route_table_name
  network_security_group_name = module.azure_network_security_group.network_security_group_name
  service_endpoints           = []
}
