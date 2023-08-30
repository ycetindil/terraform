module "private_endpoint_xxx" {
  source = "./modules/private_endpoint"

  name                = "sql-project101-prod-001-pep"
  resource_group_name = module.resource_group_xxx.name
  location            = var.private_endpoint_xxx.location
  subnet_id           = module.subnet_xxx.id
  private_service_connection = merge(
    var.private_endpoint_xxx.private_service_connection,
    { private_connection_resource_id = module.mssql_server_xxx.id }
  )
  private_dns_zone_group = merge(
    var.private_endpoint_xxx.private_dns_zone_group,
    { private_dns_zone_ids = [module.private_dns_zone_xxx.id] }
  )
}