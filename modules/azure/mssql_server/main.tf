# Manages a Microsoft SQL Azure Database Server.
# Note: All arguments including the administrator login and password will be stored in the raw state as plain-text. Read more about sensitive data in state at https://www.terraform.io/docs/state/sensitive-data.html.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server
resource "azurerm_mssql_server" "mssql_server" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.mssql_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  tags                         = var.tags
}
