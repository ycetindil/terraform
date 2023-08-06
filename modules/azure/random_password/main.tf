resource "random_password" "random_password" {
  length           = var.length
  lower            = var.lower
  min_lower        = var.min_lower
  upper            = var.upper
  min_upper        = var.min_upper
  numeric          = var.numeric
  min_numeric      = var.min_numeric
  special          = var.special
  min_special      = var.min_special
  override_special = var.override_special
  keepers          = var.keepers
}