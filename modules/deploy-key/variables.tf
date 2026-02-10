variable "project" {
  description = "The ID or path of the project to create deploy keys on"
  type        = string
}

variable "deploy_keys" {
  description = "Deploy keys to create or enable. Key is the deploy key title. Set enable to a list of project IDs to enable the key on additional projects. Use key_id instead of key to enable an existing deploy key without creating a new one."
  type = map(object({
    key        = optional(string)
    key_id     = optional(string)
    can_push   = optional(bool)
    expires_at = optional(string)
    enable     = optional(list(string))
  }))
  default = {}

  validation {
    condition = alltrue([
      for name, dk in var.deploy_keys :
      dk.key != null || dk.key_id != null
    ])
    error_message = "Either key or key_id must be specified for each deploy key"
  }

  validation {
    condition = alltrue([
      for name, dk in var.deploy_keys :
      dk.enable != null && length(dk.enable) > 0 if dk.key == null && dk.key_id != null
    ])
    error_message = "enable is required when using key_id without key"
  }

  validation {
    condition = alltrue([
      for dk in var.deploy_keys :
      dk.expires_at == null || can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(\\.\\d+)?Z$", dk.expires_at))
    ])
    error_message = "expires_at must be in RFC3339 format (e.g., 2025-12-31T23:59:59Z)"
  }
}

variable "deploy_keys_file" {
  description = "Path to YAML file containing deploy keys definition. Merged with deploy_keys variable."
  type        = string
  default     = null
}

variable "create_only" {
  description = "If set to true, resources will only be created and ignore attribute changes after creation"
  type        = bool
  default     = false
}
