mssql_server_xxx = {
  name = "sql-project101-prod-eastus-001"
  # resource_group_name is provided by the root main.
  location            = "eastus"
  mssql_version       = "12.0"
  administrator_login = "admin1234"
  # administrator_login_password is provided by the root main.
}