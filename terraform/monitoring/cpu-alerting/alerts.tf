module "alerting" {
  source  = "claranet/alerting/azurerm"
  version = "5.1.0"

  location_short = module.azure_region.location_short
  client_name    = var.client
  environment    = var.environment
  stack          = var.stack

  resource_group_name     = var.resource_group_name
  action_group_short_name = "Alerting"
}


resource "azurerm_monitor_metric_alert" "alert" {
  name                = join("-", ["mma", var.client, module.azure_region.location_short, var.environment, var.stack])
  resource_group_name = var.resource_group_name
  scopes              = [var.vm_id]
  description         = var.metric_description

  criteria = {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.threshold
  }

  action {
    action_group_id = module.alerting.action_group_id
  }
}
