variable "display_name" {
    description = "The name of the Fabric workspace"
    type        = string
}

variable "description" {
    description = "Description of the Fabric workspace"
    type        = string
    default     = ""
}

variable "capacity_id" {
    description = "The ID of the Fabric capacity to associate with the workspace"
    type        = string
}

variable "fabric_domain_id" {
    description = "The ID of the Fabric domain to associate with the workspace"
    type        = string
    default     = ""
}
