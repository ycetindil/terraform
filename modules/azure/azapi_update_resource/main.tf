# This resource can manage a subset of any existing Azure resource manager resource's properties.
# Note: This resource is used to add or modify properties on an existing resource. When delete azapi_update_resource, no operation will be performed, and these properties will stay unchanged. If you want to restore the modified properties to some values, you must apply the restored properties before deleting.
# https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/azapi_update_resource
resource "azapi_update_resource" "azapi_update_resource" {
  name                    = var.name
  parent_id               = var.parent_id
  resource_id             = var.resource_id
  type                    = var.type
  body                    = jsonencode(var.body)
  response_export_values  = var.response_export_values
  locks                   = var.locks
  ignore_casing           = var.ignore_casing
  ignore_missing_property = var.ignore_missing_property
}