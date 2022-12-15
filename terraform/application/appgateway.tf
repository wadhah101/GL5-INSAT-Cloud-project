
locals {
  base_name = "${var.stack}-${var.client}-${module.azure_region.location_short}-${var.environment}"
}

module "appgw_v2" {
  source  = "claranet/app-gateway/azurerm"
  version = "7.2.1"

  stack               = var.stack
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client
  resource_group_name = var.resource_group_name

  virtual_network_name = module.azure_network_vnet.virtual_network_name

  subnet_cidr = "10.0.1.0/24"

  appgw_backend_http_settings = [{
    name                  = "${local.base_name}-backhttpsettings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 300
  }]


  appgw_backend_pools = [{
    name  = "${local.base_name}-backendpool"
    fqdns = [azurerm_container_group.container.ip_address]
  }]

  appgw_routings = [{
    name                       = "${local.base_name}-routing-https"
    rule_type                  = "Basic"
    http_listener_name         = "${local.base_name}-listener-https"
    backend_address_pool_name  = "${local.base_name}-backendpool"
    backend_http_settings_name = "${local.base_name}-backhttpsettings"
  }]

  custom_frontend_ip_configuration_name = "${local.base_name}-frontipconfig"

  appgw_http_listeners = [{
    name                           = "${local.base_name}-listener-https"
    frontend_ip_configuration_name = "${local.base_name}-frontipconfig"
    frontend_port_name             = "frontend-https-port"
    protocol                       = "Http"
    # ssl_certificate_name           = "${local.base_name}-example-com-sslcert"
    # require_sni = true
    # host_name   = "example.com"
  }]

  frontend_port_settings = [{
    name = "frontend-https-port"
    port = 80
  }]


  ssl_policy = {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  appgw_rewrite_rule_set = [{
    name = "${local.base_name}-example-rewrite-rule-set"
    rewrite_rules = [
      {
        name          = "${local.base_name}-example-rewrite-rule-response-header"
        rule_sequence = 100
        conditions = [
          {
            ignore_case = true
            negate      = false
            pattern     = "text/html(.*)"
            variable    = "http_resp_Content-Type"
          }
        ]
        response_header_configurations = [{
          header_name  = "X-Frame-Options"
          header_value = "DENY"
        }]
      },
      {
        name          = "${local.base_name}-example-rewrite-rule-url"
        rule_sequence = 100
        conditions = [
          {
            ignore_case = false
            negate      = false
            pattern     = ".*-R[0-9]{10,10}\\.html"
            variable    = "var_uri_path"
          },
          {
            ignore_case = true
            negate      = false
            pattern     = ".*\\.fr"
            variable    = "var_host"
          }
        ]
        url_reroute = {
          path         = "/fr{var_uri_path}"
          query_string = null
          reroute      = false
        }
      }
    ]
  }]


  appgw_url_path_map = [{
    name                               = "${local.base_name}-example-url-path-map"
    default_backend_http_settings_name = "${local.base_name}-backhttpsettings"
    default_backend_address_pool_name  = "${local.base_name}-backendpool"
    default_rewrite_rule_set_name      = "${local.base_name}-example-rewrite-rule-set"
    path_rules = [
      {
        name                       = "${local.base_name}-example-url-path-rule"
        backend_address_pool_name  = "${local.base_name}-backendpool"
        backend_http_settings_name = "${local.base_name}-backhttpsettings"
        rewrite_rule_set_name      = "${local.base_name}-example-rewrite-rule-set"
        paths                      = ["/demo/"]
      }
    ]
  }]


  autoscaling_parameters = {
    min_capacity = 1
    max_capacity = 2
  }

  logs_destinations_ids = []
}
