# Manages a Resource Group.
# Note: Azure automatically deletes any Resources nested within the Resource Group when a Resource Group is deleted.
# Note: Version 2.72 and later of the Azure Provider include a Feature Toggle which can error if there are any Resources left within the Resource Group at deletion time. This Feature Toggle is disabled in 2.x but enabled by default from 3.0 onwards, and is intended to avoid the unintentional destruction of resources managed outside of Terraform (for example, provisioned by an ARM Template). See the Features block documentation at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#features for more information on Feature Toggles within Terraform.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "resource_group" {
  location   = var.location
  name       = var.name
  managed_by = var.managed_by
  tags       = var.tags
}