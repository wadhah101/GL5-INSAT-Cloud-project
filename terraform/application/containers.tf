
resource "azurerm_container_group" "container" {
  name                = module.naming.container_group.name
  location            = module.azure_region.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Private"
  os_type             = "Linux"

  identity {
    type = "SystemAssigned"
  }

  subnet_ids = [module.azure_network_subnet.subnet_id]

  exposed_port = [{
    port     = 80
    protocol = "TCP"
  }]

  container {

    name  = "nginx"
    image = "nginx"

    cpu    = 2
    memory = 4
    environment_variables = {
      PORT = 80
    }

    readiness_probe {
      http_get {
        path   = "/"
        port   = 80
        scheme = "Http"
      }
    }

    secure_environment_variables = {
      DATABASE_CONNECTION_STRING = ""
    }

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}



# resource "azurerm_role_assignment" "example" {
#   scope                = data.azurerm_subscription.primary.id
#   role_definition_name = "Reader"
#   principal_id         = azurerm_container_group.container.identity[0].principal_id
# }
