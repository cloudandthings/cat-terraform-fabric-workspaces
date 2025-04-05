variable "fabric_provider" {
  type = object({
    tenant_id     = string
    client_id     = string
    client_secret = string
  })
}

variable "fabric_notebooks" {
  type = list(object({
    workspace_id  = string
    display_name  = string
  }))
}