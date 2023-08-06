variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "tags" {
  default = null
  type    = map(string)
}

variable "secrets" {
  default = {}
  type = map(object({
    name = string
    value = object({
      literal = optional(string, null)
      random  = optional(any, null) // pass directly to random secret module
    })
  }))
  # Either secrets is {}, or exactly one of literal and random variables of the value variables should have a value
  validation {
    condition = (
      var.secrets == {} || // ??? Maybe null rather than empty map
      alltrue([
        for secret in var.secrets :
        (
          try(secret.value.literal, null) != null &&
          try(secret.value.random, null) == null
        ) ||
        (
          try(secret.value.literal, null) == null &&
          try(secret.value.random, null) != null
        )
      ])
    )
    error_message = "Exactly one of literal and random variables of the value variables should have a value"
  }
}