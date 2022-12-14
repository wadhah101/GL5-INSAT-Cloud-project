terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

variable "subscription_id" {
  type = string
}

resource "azurerm_policy_definition" "definition" {
  name         = "allowed-skus-custom"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed sku types custom"

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

resource "azurerm_subscription_policy_assignment" "assignment" {
  name                 = "allowed-sku-assignment"
  policy_definition_id = azurerm_policy_definition.definition.id
  subscription_id      = var.subscription_id
}
