terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}


module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "6.0.0"

  azure_region = var.location
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.2.0"
  suffix  = [var.client, module.azure_region.location_short, var.environment, var.stack]
}
