variable "fabric_provider" {
  type = object({
    tenant_id     = string
  })
}

variable "workspace" {
  type = object({
    display_name = string
    description  = optional(string, "")
  })
}