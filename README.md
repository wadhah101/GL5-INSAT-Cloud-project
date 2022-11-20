# GL5-INSAT-Cloud-project

this Project aims to deploy a demo of SCCA-compliant Landing Zone following [this architecture](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) as guideline

![archi](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/media/ns-arch-cust-expanded.svg#lightbox)

4 Tiers will be implimentend with Vnet isolation communicationg through azure expressroute:

- Hub Spoke 
- Identity and auth tier
- Infra and operations tier
- DevSecops and any shared services tier

## Tools

Terraform with azurerm and azurecaf providers will be leveraged. possible usage of azure biceps for preview features
