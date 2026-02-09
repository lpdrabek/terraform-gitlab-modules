variable "target" {
  description = "Target for deploy tokens. Accepts \"project\" or \"group\""
  type = object({
    type = string # "project" or "group"
    id   = string
  })

  validation {
    condition     = contains(["project", "group"], var.target.type)
    error_message = "Target type must be either 'project' or 'group'"
  }
}

variable "tokens" {
  description = "Deploy tokens to create. Key is token name. Either provide this directly or use tokens_file."
  type = map(object({
    scopes                        = list(string)
    username                      = optional(string)
    expires_at                    = optional(string)
    validate_past_expiration_date = optional(bool)
  }))
  default = {}

  validation {
    condition = alltrue([
      for token in var.tokens :
      length(token.scopes) > 0
    ])
    error_message = "At least one scope must be specified for each deploy token"
  }

  validation {
    condition = alltrue([
      for token in var.tokens :
      alltrue([
        for scope in token.scopes :
        contains([
          "read_repository", "read_registry", "write_registry",
          "read_virtual_registry", "write_virtual_registry",
          "read_package_registry", "write_package_registry"
        ], scope)
      ])
    ])
    error_message = "Invalid scope. Valid scopes are: read_repository, read_registry, write_registry, read_virtual_registry, write_virtual_registry, read_package_registry, write_package_registry"
  }

  validation {
    condition = alltrue([
      for token in var.tokens :
      token.expires_at == null || can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(\\.\\d+)?Z$", token.expires_at))
    ])
    error_message = "expires_at must be in RFC3339 format (e.g., 2025-12-31T23:59:59Z)"
  }
}

variable "tokens_file" {
  description = "Path to YAML file containing deploy tokens definition. Merged with tokens variable."
  type        = string
  default     = null
}

variable "create_only" {
  description = "If set to true, tokens will only be created and ignore attribute changes after creation"
  type        = bool
  default     = false
}
