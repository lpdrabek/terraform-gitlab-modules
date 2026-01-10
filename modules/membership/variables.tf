variable "target" {
  description = "Target for membership. Accepts \"project\" or \"group\""
  type = object({
    type = string # "project", "group"
    id   = string
  })

  validation {
    condition     = contains(["project", "group"], var.target.type)
    error_message = "Target type must be 'project' or 'group'"
  }
}

variable "membership_file" {
  description = "Path to YAML file containing membership configuration"
  type        = string
  default     = null
}

variable "membership" {
  description = "Map of access levels to membership configurations"
  type = map(object({
    users                         = list(string)
    find_users                    = optional(string, "email") # email, username, userid
    expires_at                    = optional(string)          # YYYY-MM-DD
    member_role_id                = optional(number)
    skip_subresources_on_destroy  = optional(bool)
    unassign_issuables_on_destroy = optional(bool)
  }))
  default = {}

  validation {
    condition = alltrue([
      for level, config in var.membership :
      contains(["email", "username", "userid"], config.find_users)
    ])
    error_message = "find_users must be one of: email, username, userid"
  }

  validation {
    condition = alltrue([
      for level, config in var.membership :
      config.expires_at == null || can(regex("^\\d{4}-\\d{2}-\\d{2}$", config.expires_at))
    ])
    error_message = "expires_at must be in YYYY-MM-DD format"
  }
}
