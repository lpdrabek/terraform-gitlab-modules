variable "target" {
  description = "Target for issue boards. Accepts \"project\" or \"group\""
  type = object({
    type = string # "project" or "group"
    id   = string
  })

  validation {
    condition     = contains(["project", "group"], var.target.type)
    error_message = "Target type must be either 'project' or 'group'"
  }
}


variable "boards" {
  description = "Issue boards that will be applied to the target. Merged with boards_file internally"
  type = map(object({
    labels       = optional(set(string))
    assignee_id  = optional(number)
    milestone_id = optional(number)
    weight       = optional(number)
    lists = optional(list(object({
      assignee_id  = optional(number)
      iteration_id = optional(number)
      label_id     = optional(number)
      milestone_id = optional(number)
      position     = optional(number) # For group boards only
    })))
  }))
  default = {}
}

variable "boards_file" {
  description = "Path to YAML file containing issue boards. Merged with boards internally"
  type        = string
  default     = null
}
