variable "fabric_provider" {
  type = object({
    tenant_id     = string
    client_id     = string
    client_secret = string
    workspace_id  = string
  })
}

variable "fabric_environment" {
  type = object({
    display_name  = string
    description   = string
  })
}

variable "fabric_notebooks" {
  type = list(object({
    display_name  = string
    description   = string
    local_file_path = string
  }))
}