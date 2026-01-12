variable "project" {
  description = "Project ID or path to apply branch protection to"
  type        = string
}

variable "branches" {
  description = "Map of branches and their protection settings. Map key is used as the branch name."
  type = map(object({
    search_by                    = optional(string, "email")
    push_access_level            = optional(string)
    merge_access_level           = optional(string)
    unprotect_access_level       = optional(string)
    allow_force_push             = optional(bool, false)
    code_owner_approval_required = optional(bool, false)      # Premium/Ultimate only
    allowed_to_push              = optional(list(string), []) # Premium/Ultimate only
    allowed_to_merge             = optional(list(string), []) # Premium/Ultimate only
    allowed_to_unprotect         = optional(list(string), []) # Premium/Ultimate only
    groups_allowed_to_push       = optional(list(string), []) # Premium/Ultimate only
    groups_allowed_to_merge      = optional(list(string), []) # Premium/Ultimate only
    groups_allowed_to_unprotect  = optional(list(string), []) # Premium/Ultimate only
  }))
  default = {}

  validation {
    condition = alltrue([
      for branch, config in var.branches :
      contains(["email", "username", "userid", "groupid", "fullpath"], config.search_by)
    ])
    error_message = "search_by must be one of: email, username, userid, groupid, fullpath"
  }

  validation {
    condition = alltrue([
      for branch, config in var.branches :
      config.push_access_level == null ||
      contains(["no one", "developer", "maintainer"], config.push_access_level)
    ])
    error_message = "push_access_level must be one of: no one, developer, maintainer"
  }

  validation {
    condition = alltrue([
      for branch, config in var.branches :
      config.merge_access_level == null ||
      contains(["no one", "developer", "maintainer"], config.merge_access_level)
    ])
    error_message = "merge_access_level must be one of: no one, developer, maintainer"
  }

  validation {
    condition = alltrue([
      for branch, config in var.branches :
      config.unprotect_access_level == null ||
      contains(["no one", "developer", "maintainer"], config.unprotect_access_level)
    ])
    error_message = "unprotect_access_level must be one of: no one, developer, maintainer"
  }
}

variable "branches_file" {
  description = "Path to YAML file containing branch protection configuration. Merged with branches variable."
  type        = string
  default     = null
}

variable "create_only" {
  description = "If true, branch protections will only be created and ignore attribute changes after creation"
  type        = bool
  default     = false
}
