variable "type" {
  description = "Type of mirror to configure. Use 'push' to push changes to a remote repository, or 'pull' to pull changes from a remote repository."
  type        = string

  validation {
    condition     = contains(["push", "pull"], var.type)
    error_message = "type must be one of: push, pull"
  }
}

variable "target" {
  description = "Map of project mirrors to configure. The map key is the project ID or path."
  type = map(object({
    url                 = string               # The URL of the remote repository to be mirrored
    enabled             = optional(bool, true) # Determines if the mirror is enabled
    mirror_branch_regex = optional(string)     # Regular expression for branches to mirror (Premium/Ultimate only)

    auth_method             = optional(string) # Authentication method: ssh_public_key, password
    keep_divergent_refs     = optional(bool)   # Skip divergent refs instead of failing
    only_protected_branches = optional(bool)   # Only mirror protected branches

    auth_password                       = optional(string) # Authentication password or token
    auth_user                           = optional(string) # Authentication username
    mirror_overwrites_diverged_branches = optional(bool)   # Overwrite diverged branches on target
    mirror_trigger_builds               = optional(bool)   # Trigger pipelines when mirror updates
    only_mirror_protected_branches      = optional(bool)   # Only mirror protected branches
  }))
  default = {}

  validation {
    condition = alltrue([
      for project, config in var.target :
      config.url != null && config.url != ""
    ])
    error_message = "url is required for all mirror targets"
  }

  validation {
    condition = alltrue([
      for project, config in var.target :
      config.auth_method == null || contains(["ssh_public_key", "password"], config.auth_method)
    ])
    error_message = "auth_method must be one of: ssh_public_key, password"
  }
}

variable "target_file" {
  description = "Path to YAML file containing mirror configuration. Merged with target variable."
  type        = string
  default     = null
}
