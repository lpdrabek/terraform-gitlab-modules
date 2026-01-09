variable "target" {
  description = "Target for labels. Accepts \"project\" or \"group\""
  type = object({
    type = string # "project" or "group"
    id   = string
  })

  validation {
    condition     = contains(["project", "group"], var.target.type)
    error_message = "Target type must be either 'project' or 'group'"
  }
}

variable "variables" {
  description = "A map of variables and their properties"
  type = map(object({
    value             = string
    description       = optional(string)
    environment_scope = optional(string)
    hidden            = optional(bool, false)
    masked            = optional(bool, false)
    protected         = optional(bool, false)
    raw               = optional(bool, false)
    variable_type     = optional(string, "env_var")
  }))
  default = {}

  validation {
    condition = alltrue([
      for key, variable in var.variables :
      variable.variable_type == null || contains(["env_var", "file"], variable.variable_type)
    ])
    error_message = "variable_type must be one of: env_var, file"
  }

  validation {
    condition = alltrue([
      for key, variable in var.variables :
      !variable.masked || (variable.masked && variable.value != null && length(variable.value) >= 8)
    ])
    error_message = "Masked variables must have a value of at least 8 characters"
  }

  validation {
    condition = alltrue([
      for key, variable in var.variables :
      !variable.masked || !variable.raw
    ])
    error_message = "A variable cannot be both masked and raw (raw variables cannot be masked)"
  }

  validation {
    condition = alltrue([
      for key, variable in var.variables :
      variable.environment_scope == null || can(regex("^[a-zA-Z0-9*/_-]+$", variable.environment_scope))
    ])
    error_message = "environment_scope must contain only alphanumeric characters, *, /, _, or - (e.g., 'production', 'staging/*', '*')"
  }

  validation {
    condition = alltrue([
      for key, variable in var.variables :
      !variable.hidden || variable.masked
    ])
    error_message = "Hidden variables must also be masked (hidden requires masked = true)"
  }
}

variable "variables_file" {
  description = "Path to YAML file containing variables"
  type        = string
  default     = null
}
