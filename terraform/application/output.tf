output "website_api_key" {
  value     = azurerm_static_site.website.api_key
  sensitive = true
}

output "website_default_url" {
  value = azurerm_static_site.website.default_host_name
}

