variable "project_id" {
  description = "ID of the project the milestones are assigned to"
  type        = string
}

variable "milestones" {
  description = "Map of project milestones to create. Map key is used as the milestone title."
  type = map(object({
    description = optional(string)
    state       = optional(string)
    start_date  = optional(string)
    due_date    = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for key, milestone in var.milestones :
      milestone.state == null || milestone.state == "" || contains(["active", "closed"], milestone.state)
    ])
    error_message = "state must be either 'active' or 'closed'"
  }

  validation {
    condition = alltrue([
      for key, milestone in var.milestones :
      milestone.start_date == null || milestone.start_date == "" || can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", milestone.start_date))
    ])
    error_message = "start_date must be in YYYY-MM-DD format (e.g., 2026-01-15)"
  }

  validation {
    condition = alltrue([
      for key, milestone in var.milestones :
      milestone.due_date == null || milestone.due_date == "" || can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", milestone.due_date))
    ])
    error_message = "due_date must be in YYYY-MM-DD format (e.g., 2026-01-15)"
  }

  validation {
    condition = alltrue([
      for key, milestone in var.milestones :
      (milestone.start_date == null || milestone.start_date == "" ||
        milestone.due_date == null || milestone.due_date == "" ||
      milestone.start_date <= milestone.due_date)
    ])
    error_message = "start_date must be before or equal to due_date"
  }
}

variable "milestones_file" {
  description = "Path to YAML file containing milestones. Merged with milestones variable."
  type        = string
  default     = null
}

variable "create_only" {
  description = "If set to true, module will only create milestones and ignore other attributes after creation"
  type        = bool
  default     = false
}
