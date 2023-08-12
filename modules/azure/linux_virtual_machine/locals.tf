locals {
  admin_ssh_keys_from_azure = {
    for key, ssh_key in var.admin_ssh_keys :
    key => ssh_key.public_key.from_azure
    if ssh_key.public_key.from_azure != null
  }
}