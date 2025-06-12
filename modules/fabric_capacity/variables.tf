variable "location" {
  type        = string
  description = "Location of the resource group and modules"
  default     = "North Europe"
}

variable "basename" {
  type        = string
  description = "Base name for module resources"
  default     = "test"
}

variable "sku" {
  type        = string
  description = "F SKU"
  default     = "F2"
}

variable "admin_email" {
  type        = string
  description = "Admin email address"
  default     = "<>"
}