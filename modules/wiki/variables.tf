variable "project_id" {
  description = "ID of the project for the wiki pages"
  type        = string
}

variable "pages" {
  description = "Map of pages to create in the project"
  type = map(object({
    title   = optional(string)
    content = optional(string)
    format  = optional(string, "markdown")
  }))
  default = {}
}

variable "pages_file" {
  description = "Path to YAML file containing wiki pages"
  type        = string
  default     = null
}

variable "create_only" {
  description = "If set to true, module will only create the pages and ignore other attributes after creation"
  type        = bool
  default     = false
}
