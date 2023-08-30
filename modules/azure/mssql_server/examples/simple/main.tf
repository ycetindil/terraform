module "mssql_server_xxx" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/mssql_server"

  name                = var.mssql_server_xxx.name
  resource_group_name = module.resource_group_xxx.name
  location            = var.mssql_server_xxx.location
  mssql_version       = var.mssql_server_xxx.mssql_version
  administrator_login = var.mssql_server_xxx.administrator_login
  # administrator_login_password = module.key_vault_secret_xxx.value
  administrator_login_password = module.random_password_xxx.result
}