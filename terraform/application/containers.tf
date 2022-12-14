
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

    name  = "backend1"
    image = "mellywins/backend-layer-1:finalthree"

    cpu    = 2
    memory = 4

    environment_variables = {
      PORT         = 80
      DB_HOST      = "c.maindbwadhah.postgres.database.azure.com"
      DB_PORT      = 5432
      DB_USERNAME  = "citus"
      DB_PASSWORD  = "J5xZnK9taHygFZS"
      DB_DATABASE  = "citus"
      UPSTREAM_URL = "http://${azurerm_container_group.container2.ip_address}"
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


output "ip_address_container1" {
  value = azurerm_container_group.container.ip_address
}


# psql "host=psql-w-frc-demo-appl.postgres.database.azure.com port=5432 dbname=exampledb user=psqladmin@psql-w-frc-demo-appl password=H@Sh1CoR3!"
