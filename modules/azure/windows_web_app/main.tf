data "azurerm_service_plan" "service_plan" {
  name                = var.service_plan.name
  resource_group_name = var.service_plan.resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet.name
  virtual_network_name = var.subnet.virtual_network_name
  resource_group_name  = var.subnet.subnet_resource_group_name
}

resource "azurerm_windows_web_app" "windows_web_app" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  service_plan_id           = data.azurerm_service_plan.service_plan.id
  app_settings              = var.app_settings
  virtual_network_subnet_id = data.azurerm_subnet.subnet.id

  dynamic "logs" {
    for_each = var.logs != null ? [1] : []

    content {
      detailed_error_messages = var.logs.detailed_error_messages
      failed_request_tracing  = var.logs.failed_request_tracing

      dynamic "application_logs" {
        for_each = var.logs.application_logs != null ? [1] : []

        content {
          file_system_level = var.logs.application_logs.file_system_level

          dynamic "azure_blob_storage" {
            for_each = var.logs.application_logs.azure_blob_storage != null ? [1] : []

            content {
              level             = var.logs.application_logs.azure_blob_storage.level
              retention_in_days = var.logs.application_logs.azure_blob_storage.retention_in_days
              sas_url           = var.logs.application_logs.azure_blob_storage.sas_url
            }
          }
        }
      }
    }
  }
  tags = var.tags

  dynamic "identity" {
    for_each = var.identity != null ? [1] : []

    content {
      type = var.identity.type
    }
  }

  site_config {
    application_stack {
      current_stack  = var.site_config.application_stack.current_stack
      dotnet_version = var.site_config.application_stack.dotnet_version
    }
  }

  lifecycle {
    ignore_changes = [virtual_network_subnet_id]
  }
}

data "azurerm_resources" "app_service_connection_target_resources" {
  for_each = var.service_connections

  name                = each.value.target_resource.name
  resource_group_name = each.value.target_resource.resource_group_name
  type                = each.value.target_resource.type
  required_tags       = each.value.target_resource.required_tags
}

data "azurerm_key_vault" "app_service_connection_key_vaults" {
  for_each = {
    for key, connection in var.service_connections :
    key => connection.secret_store.key_vault
    if connection.secret_store != null
  }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_app_service_connection" "app_service_connection" {
  for_each = var.service_connections

  name               = each.value.name
  app_service_id     = azurerm_windows_web_app.windows_web_app.id
  target_resource_id = data.azurerm_resources.app_service_connection_target_resources[each.key].resources[0].id
  authentication {
    type = each.value.authentication.type
  }
  dynamic "secret_store" {
    for_each = each.value.secret_store != null ? [1] : []

    content {
      key_vault_id = data.azurerm_key_vault.app_service_connection_key_vaults[each.key].id
    }
  }
}

resource "azurerm_dns_cname_record" "dns_cname_record" {
  count = var.custom_domain != null ? 1 : 0

  name                = var.custom_domain.subdomain_name
  zone_name           = var.custom_domain.name
  resource_group_name = var.custom_domain.resource_group_name
  ttl                 = 300
  record              = var.custom_domain.name
}

resource "azurerm_dns_txt_record" "dns_txt_record" {
  count = var.custom_domain != null ? 1 : 0

  name                = "asuid.${azurerm_dns_cname_record.dns_cname_record[0].name}"
  zone_name           = var.custom_domain.name
  resource_group_name = var.custom_domain.resource_group_name
  ttl                 = 300
  record {
    value = azurerm_windows_web_app.windows_web_app.custom_domain_verification_id
  }
}

resource "azurerm_app_service_custom_hostname_binding" "app_service_custom_hostname_binding" {
  count = var.custom_domain != null ? 1 : 0

  hostname            = trim(azurerm_dns_cname_record.dns_cname_record[0].fqdn, ".")
  app_service_name    = azurerm_windows_web_app.windows_web_app.name
  resource_group_name = azurerm_windows_web_app.windows_web_app.resource_group_name
  depends_on          = [azurerm_dns_txt_record.dns_txt_record]

  # Ignore ssl_state and thumbprint as they are managed using
  # azurerm_app_service_certificate_binding
  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }
}

resource "azurerm_app_service_managed_certificate" "custom_domain_app_service_managed_certificate" {
  count = (
    var.custom_domain != null &&
    try(var.custom_domain.certificate, null) != null &&
    try(var.custom_domain.certificate.unmanaged, null) == null
  ) ? 1 : 0

  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.app_service_custom_hostname_binding[0].id
}

data "azurerm_key_vault" "custom_domain_key_vault" {
  count = (
    var.custom_domain != null &&
    try(var.custom_domain.certificate, null) != null &&
    try(var.custom_domain.certificate.unmanaged, null) != null &&
    try(var.custom_domain.certificate.unmanaged.key_vault_secret, null) != null
  ) ? 1 : 0

  name                = var.custom_domain.certificate.unmanaged.key_vault_secret.key_vault_name
  resource_group_name = var.custom_domain.certificate.unmanaged.key_vault_secret.key_vault_resource_group_name
}

data "azurerm_key_vault_certificate" "custom_domain_key_vault_certificate" {
  count = (
    var.custom_domain != null &&
    try(var.custom_domain.certificate, null) != null &&
    try(var.custom_domain.certificate.unmanaged, null) != null &&
    try(var.custom_domain.certificate.unmanaged.key_vault_secret, null) != null
  ) ? 1 : 0

  name         = var.custom_domain.certificate.unmanaged.key_vault_secret.name
  key_vault_id = data.azurerm_key_vault.custom_domain_key_vault[0].id
}

resource "azurerm_app_service_certificate" "custom_domain_app_service_certificate" {
  count = (
    var.custom_domain != null &&
    try(var.custom_domain.certificate, null) != null &&
    try(var.custom_domain.certificate.unmanaged, null) != null
  ) ? 1 : 0

  name                = var.custom_domain.certificate.unmanaged.name
  resource_group_name = var.custom_domain.certificate.unmanaged.resource_group_name
  location            = var.custom_domain.certificate.unmanaged.location
  pfx_blob            = var.custom_domain.certificate.unmanaged.pfx_blob
  password            = var.custom_domain.certificate.unmanaged.password
  app_service_plan_id = var.custom_domain.certificate.unmanaged.app_service_plan_id
  key_vault_secret_id = data.azurerm_key_vault_certificate.custom_domain_key_vault_certificate[0].secret_id
}

resource "azurerm_app_service_certificate_binding" "app_service_certificate_binding" {
  count = var.custom_domain != null ? 1 : 0

  hostname_binding_id = azurerm_app_service_custom_hostname_binding.app_service_custom_hostname_binding[0].id
  certificate_id = try(
    azurerm_app_service_managed_certificate.custom_domain_app_service_managed_certificate[0].id,
    azurerm_app_service_certificate.custom_domain_app_service_certificate[0].id,
    "'try' function could not find a valid 'certificate_id' for the 'custom_domain': ${var.custom_domain.name}!"
  )
  ssl_state = "SniEnabled"
}