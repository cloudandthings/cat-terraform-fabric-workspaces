variable "fabric_provider" {
  type = object({
    tenant_id     = string
  })
}

variable "fabric_capacity" {
  type = object({
    location      = string
    prefix        = string
    postfix       = string
    sku           = string
    admin_email   = string
  })
}

variable "workspace" {
  type = object({
    display_name = string
    description  = optional(string, "")
  })
}