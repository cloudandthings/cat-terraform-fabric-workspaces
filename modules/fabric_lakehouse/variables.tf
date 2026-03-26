variable "display_name" {
  description = "The display name of the Fabric lakehouse."
  type        = string
}

variable "description" {
  description = "Description of the Fabric lakehouse."
  type        = string
  default     = ""
}

variable "workspace_id" {
  description = "The ID of the Fabric workspace where the lakehouse will be created."
  type        = string
}

variable "enable_schemas" {
  description = "Whether to enable schemas in the lakehouse configuration."
  type        = bool
  default     = false
}