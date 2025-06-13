variable "fabric_provider" {
  type = object({
    tenant_id        = string
    subscription_id  = string
  })
}

variable "fabric_capacities" {
  type = list(object({
    location    = string
    basename    = string
    sku         = string
    admin_email = string
  }))
}

variable "workspaces" {
  type = list(object({
    display_name      = string
    description       = optional(string, "")
    capacity_basename = string
  }))
}