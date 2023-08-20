module "random_password_xxx" {
  length           = var.random_password_xxx.length
  lower            = try(var.random_password_xxx.lower, null)
  min_lower        = try(var.random_password_xxx.min_lower, null)
  upper            = try(var.random_password_xxx.upper, null)
  min_upper        = try(var.random_password_xxx.min_upper, null)
  numeric          = try(var.random_password_xxx.numeric, null)
  min_numeric      = try(var.random_password_xxx.min_numeric, null)
  special          = try(var.random_password_xxx.special, null)
  min_special      = try(var.random_password_xxx.min_special, null)
  override_special = try(var.random_password_xxx.override_special, null)
  keepers          = try(var.random_password_xxx.keepers, null)
}