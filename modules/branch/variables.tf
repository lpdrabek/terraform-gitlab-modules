variable "project" {
  description = "Project ID or path to apply branches to"
  type        = string
}

variable "branches" {
  description = "Branches to create on the project"
  type = map(object({
    create_from     = string
    keep_on_destroy = optional(bool)
  }))
}

variable "branches_file" {
  description = "Path to YAML file containing branches configuration. Merged with branches variable."
  type        = string
  default     = null
}
