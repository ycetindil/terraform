variable "length" {
  type = number
}

variable "lower" {
  default = null
  type    = bool
}

variable "min_lower" {
  default = null
  type    = number
}

variable "upper" {
  default = null
  type    = bool
}

variable "min_upper" {
  default = null
  type    = number
}

variable "numeric" {
  default = null
  type    = bool
}

variable "min_numeric" {
  default = null
  type    = number
}

variable "special" {
  default = null
  type    = bool
}

variable "min_special" {
  default = null
  type    = number
}

variable "override_special" {
  default = null
  type    = string
}

variable "keepers" {
  default = null
  type    = map(string)
}