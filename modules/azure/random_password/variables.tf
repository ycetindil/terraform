variable "length" {
  description = <<EOD
		(Required) The length of the string desired.
		The minimum value for length is 1 and, length must also be >= (min_upper + min_lower + min_numeric + min_special).
	EOD
  type        = number
}

variable "keepers" {
  description = <<EOD
		(Optional) Arbitrary map of values that, when changed, will trigger recreation of resource. See the main provider documentation at https://registry.terraform.io/providers/hashicorp/random/latest/ for more information.
	EOD
  default     = null
  type        = map(string)
}

variable "lower" {
  description = <<EOD
		(Optional) Include lowercase alphabet characters in the result.
		Default value is true.
	EOD
  default     = null
  type        = bool
}

variable "min_lower" {
  description = <<EOD
		(Optional) Minimum number of lowercase alphabet characters in the result.
		Default value is 0.
	EOD
  default     = null
  type        = number
}

variable "min_numeric" {
  description = <<EOD
		(Optional) Minimum number of numeric characters in the result.
		Default value is 0.
	EOD
  default     = null
  type        = number
}

variable "min_special" {
  description = <<EOD
		(Optional) Minimum number of special characters in the result.
		Default value is 0.
	EOD
  default     = null
  type        = number
}

variable "min_upper" {
  description = <<EOD
		(Number) Minimum number of uppercase alphabet characters in the result.
		Default value is 0.
	EOD
  default     = null
  type        = number
}

variable "numeric" {
  description = <<EOD
		(Optional) Include numeric characters in the result. Default value is true.
	EOD
  default     = null
  type        = bool
}

variable "override_special" {
  description = <<EOD
		(Optional) Supply your own list of special characters to use for string generation.
		This overrides the default character list in the special argument.
		The special argument must still be set to true for any overwritten characters to be used in generation.
	EOD
  default     = null
  type        = string
}

variable "special" {
  description = <<EOD
		(Optional) Include special characters in the result.
		These are !@#$%&*()-_=+[]{}<>:?.
		Default value is true.
	EOD
  default     = null
  type        = bool
}

variable "upper" {
  description = <<EOD
		(Optional) Include uppercase alphabet characters in the result.
		Default value is true.
	EOD
  default     = null
  type        = bool
}