variable "target" {
  description = "Target for labels. Accepts \"project\", \"group\" or \"personal\""
  type = object({
    type = string # "project", "group", "personal"
    id   = string
  })

  validation {
    condition     = contains(["project", "group", "personal"], var.target.type)
    error_message = "Target type must be 'project', 'group' or 'personal'"
  }
}

variable "access_tokens_file" {
  description = "Path to YAML file containing access tokens"
  type        = string
  default     = null
}

variable "access_tokens" {
  description = "Map of access tokens to create. Key is token name."
  default     = {}
  type = map(object({
    scopes                        = list(string)
    access_level                  = optional(string, "maintainer")
    description                   = optional(string)
    expires_at                    = optional(string) #YYYY-MM-DD
    validate_past_expiration_date = optional(bool)
    # rotation_configuration = optional(map(object({
    #   expiration_days    = optional(number)
    #   rotate_before_days = optional(number)
    # }))) # TODO?
  }))

  validation {
    condition = alltrue([
      for token in var.access_tokens : token.access_level == null || contains(
        ["no one", "minimal", "guest", "planner", "reporter", "developer", "maintainer", "owner"],
        token.access_level
      )
    ])
    error_message = "Access level must be one of: no one, minimal, guest, planner, reporter, developer, maintainer, owner"
  }

  # access_level is only valid for group and project tokens - validated via precondition in main.tf

  validation {
    condition = alltrue([
      for token in var.access_tokens :
      token.expires_at != null
    ])
    error_message = "expires_at is required for all access tokens"
  }

  validation {
    condition = alltrue([
      for token in var.access_tokens :
      can(regex("^\\d{4}-\\d{2}-\\d{2}$", token.expires_at))
    ])
    error_message = "expires_at must be in YYYY-MM-DD format"
  }

  validation {
    condition = alltrue([
      for token in var.access_tokens :
      length(token.scopes) > 0
    ])
    error_message = "At least one scope must be specified for each access token"
  }

  validation {
    condition = alltrue([
      for token in var.access_tokens :
      alltrue([
        for scope in token.scopes :
        contains([
          "api", "read_user", "read_api", "read_repository", "write_repository",
          "read_registry", "write_registry", "read_virtual_registry", "write_virtual_registry",
          "sudo", "admin_mode", "create_runner", "manage_runner", "ai_features",
          "k8s_proxy", "self_rotate", "read_service_ping", "read_observability", "write_observability"
        ], scope)
      ])
    ])
    error_message = "Invalid scope. Valid scopes are: api, read_user, read_api, read_repository, write_repository, read_registry, write_registry, read_virtual_registry, write_virtual_registry, sudo, admin_mode, create_runner, manage_runner, ai_features, k8s_proxy, self_rotate, read_service_ping, read_observability, write_observability. Note: some scopes are only valid for specific token types (personal/group/project)."
  }
}
