variable "name" {
  description = <<EOD
		(Required) Specifies the name of the Key Vault Secret.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "variable_name" {
  description = <<EOD
		value - (Required) Specifies the value of the Key Vault Secret.
		- NOTE: Key Vault strips newlines. To preserve newlines in multi-line secrets try replacing them with \n or by base 64 encoding them with replace(file("my_secret_file"), "/\n/", "\n") or base64encode(file("my_secret_file")), respectively.
	EOD
  type        = string
}

variable "key_vault_id" {
  description = <<EOD
		(Required) The ID of the Key Vault where the Secret should be created.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}