terraform {
  backend "azurerm" {
    resource_group_name  = "qantev_tf_state"
    storage_account_name = "tfstate2a363f29f4e1b913"
    container_name       = "tfstate"
    key                  = "archive-subscription-logs.tfstate"
  }
}
