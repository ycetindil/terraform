variable "network_groups" {
  default = null
  type = map(object({
    name = string
    policies = map(object({
      name = string
      subscription = object({
        is_current = bool
        id         = optional(string, "")
      })
      rule = object({
        effect     = string
        conditions = string
      })
    }))
    connectivity_configurations = map(object({
      name                  = string
      connectivity_topology = string
      applies_to_group = object({
        group_connectivity = string
      })
      deployment = object({
        location     = string
        scope_access = string
      })
    }))
  }))
}