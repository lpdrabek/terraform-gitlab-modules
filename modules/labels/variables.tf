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

variable "labels" {
  description = "Labels that will be applied to the target. Either provide this directly or use labels_file."
  type = map(object({
    color       = optional(string)
    description = optional(string)
  }))
  default = {}
}

variable "labels_file" {
  description = "Path to YAML file containing labels definition. Mutually exclusive with labels variable."
  type        = string
  default     = null
}

variable "create_only" {
  description = "If set to true, labels will only be created and ignore attribute changes after creation"
  type        = bool
  default     = false
}
