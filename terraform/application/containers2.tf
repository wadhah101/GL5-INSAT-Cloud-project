
resource "azurerm_container_group" "container2" {
  name                = "${module.naming.container_group.name}-second"
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

    name  = "backend2"
    image = "mellywins/backend-layer-2"

    cpu    = 2
    memory = 4
    environment_variables = {
      PORT          = 80
      DOWNLOAD_PATH = "/mnt/storage"
    }

    # readiness_probe {
    #   http_get {
    #     path   = "/ready"
    #     port   = 80
    #     scheme = "Http"
    #   }
    # }

    # liveness_probe {
    #   http_get {
    #     path   = "/healthz"
    #     port   = 80
    #     scheme = "Http"
    #   }
    # }

    secure_environment_variables = {

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
