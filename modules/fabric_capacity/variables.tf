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

variable "admin_emails" {
  type        = list(string)
  description = "List of admin email addresses"
  default     = []
}

variable "scheduler" {
  description = "Optional schedule for automated pause/resume of the Fabric Capacity. Set to null to disable."
  default     = null
  type = object({
    pause_time  = string # "HH:MM" UTC
    resume_time = string # "HH:MM" UTC
    pause_days  = optional(list(string), ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
    resume_days = optional(list(string), ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"])
  })

  validation {
    condition = var.scheduler == null || can(regex(
      "^([01][0-9]|2[0-3]):[0-5][0-9]$",
      var.scheduler.pause_time
    ))
    error_message = "scheduler.pause_time must be in HH:MM (24h UTC) format, e.g. \"20:00\"."
  }

  validation {
    condition = var.scheduler == null || can(regex(
      "^([01][0-9]|2[0-3]):[0-5][0-9]$",
      var.scheduler.resume_time
    ))
    error_message = "scheduler.resume_time must be in HH:MM (24h UTC) format, e.g. \"07:00\"."
  }

  validation {
    condition = var.scheduler == null || try(
      length(var.scheduler.pause_days) > 0 && alltrue([
        for d in var.scheduler.pause_days : contains(
          ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], d
        )
      ]),
      false
    )
    error_message = "scheduler.pause_days must be a non-empty list of valid weekday names: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday."
  }

  validation {
    condition = var.scheduler == null || try(
      length(var.scheduler.resume_days) > 0 && alltrue([
        for d in var.scheduler.resume_days : contains(
          ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], d
        )
      ]),
      false
    )
    error_message = "scheduler.resume_days must be a non-empty list of valid weekday names: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday."
  }
}