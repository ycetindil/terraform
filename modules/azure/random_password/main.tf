# Identical to random_string with the exception that the result is treated as sensitive and, thus, not displayed in console output. Read more about sensitive data handling at https://www.terraform.io/docs/language/state/sensitive-data.html.
# This resource does use a cryptographic random number generator.
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "random_password" {
  length           = var.length
  keepers          = var.keepers
  lower            = var.lower
  min_lower        = var.min_lower
  min_numeric      = var.min_numeric
  min_special      = var.min_special
  min_upper        = var.min_upper
  numeric          = var.numeric
  override_special = var.override_special
  special          = var.special
  upper            = var.upper
}