variable "project_id" {
  description = "Project ID for the pipeline schedule"
  type        = string
}

variable "schedules" {
  description = "Map of pipeline schedules"
  type = map(object({
    cron           = string
    description    = string
    ref            = string # The branch/tag name to be triggered. This must be the full branch reference, for example: refs/heads/main, not main.
    active         = optional(bool)
    cron_timezone  = optional(string)
    take_ownership = optional(bool)
    variables = optional(map(object({
      value         = string
      variable_type = optional(string, "env_var")
    })), {})
  }))
  default = {}
}

variable "schedules_file" {
  description = "Path to YAML file containing pipeline schedules"
  type        = string
  default     = null
}
