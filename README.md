# GL5-INSAT-Cloud-project

this Project aims to deploy a demo of a siple Application Landing Zone following [this architecture](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) as guideline

3 Tiers will be implimentend with Vnet isolation communicationg through azure expressroute:

- Hub Spoke
- Infra and operations tier
- DevSecops and any shared services tier

## Tools

Terraform with azurerm and claranet modules will be leveraged. possible usage of azure biceps for preview features
