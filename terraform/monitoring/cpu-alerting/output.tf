output "alert_id" {
  value = azurerm_monitor_metric_alert.metric_alert.id
}

output "action_group_id" {
  value = azurerm_monitor_action_group.action_group.id
}
