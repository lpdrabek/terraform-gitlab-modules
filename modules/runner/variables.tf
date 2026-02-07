variable "runners" {
  description = "Map of GitLab user runners to create. Map key is used as a unique identifier."
  type = map(object({
    runner_type      = string
    access_level     = optional(string)
    description      = optional(string)
    group_id         = optional(number)
    locked           = optional(bool)
    maintenance_note = optional(string)
    maximum_timeout  = optional(number)
    paused           = optional(bool)
    project_id       = optional(number)
    tag_list         = optional(set(string))
    untagged         = optional(bool, false)
  }))
  default = {}

  validation {
    condition = alltrue([
      for key, runner in var.runners :
      contains(["instance_type", "group_type", "project_type"], runner.runner_type)
    ])
    error_message = "runner_type must be one of: instance_type, group_type, project_type"
  }

  validation {
    condition = alltrue([
      for key, runner in var.runners :
      runner.access_level == null || contains(["not_protected", "ref_protected"], runner.access_level)
    ])
    error_message = "access_level must be one of: not_protected, ref_protected"
  }

  validation {
    condition = alltrue([
      for key, runner in var.runners :
      runner.maximum_timeout == null || runner.maximum_timeout >= 600
    ])
    error_message = "maximum_timeout must be at least 600 (10 minutes)"
  }

  validation {
    condition = alltrue([
      for key, runner in var.runners :
      runner.runner_type != "group_type" || runner.group_id != null
    ])
    error_message = "group_id is required when runner_type is group_type"
  }

  validation {
    condition = alltrue([
      for key, runner in var.runners :
      runner.runner_type != "project_type" || runner.project_id != null
    ])
    error_message = "project_id is required when runner_type is project_type"
  }
}

variable "runners_file" {
  description = "Path to YAML file containing runners. Merged with runners variable."
  type        = string
  default     = null
}

variable "create_only" {
  description = "If set to true, runners will only be created and ignore attribute changes after creation"
  type        = bool
  default     = false
}
