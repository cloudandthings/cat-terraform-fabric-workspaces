variable "tenant_id" {
    description = "The Tenant ID for the Microsoft Fabric Provider."
    type        = string
}

variable "display_name" {
    description = "The display name for the Microsoft Fabric Provider."
    type        = string  
}

variable "description" {
    description = "The description for the Microsoft Fabric Provider."
    type        = string
}

variable "local_file_path" {
    description = "The local file path for the Microsoft Fabric Provider."
    type        = string
}

variable "client_id" {
    description = "The Client ID for the Microsoft Fabric Provider."
    type        = string
}

variable "workspace_id" {
    description = "The Workspace ID for the Microsoft Fabric Provider."
    type        = string
}

variable "client_secret" {
    description = "The Client Secret for the Microsoft Fabric Provider."
    type        = string
    sensitive   = true
}