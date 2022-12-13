terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}


data "azurerm_subscription" "current" {}

resource "azurerm_policy_definition" "example" {
  name         = "allowed-skus-custom"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed resource types"

  policy_rule = <<POLICY_RULE
  {
        "if": {
          "allOf": [
            {
              "field": "type",
              "equals": "Microsoft.Compute/virtualMachines"
            },
            {
              "not": {
                "field": "Microsoft.Compute/virtualMachines/sku.name",
                "in": ["Standard_B2s" ,"Standard_B2ms"]
              }
            }
          ]
        },
        "then": {
          "effect": "Deny"
        }
  }
POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "example" {
  name                 = "example"
  policy_definition_id = azurerm_policy_definition.example.id
  subscription_id      = data.azurerm_subscription.current.id
}
