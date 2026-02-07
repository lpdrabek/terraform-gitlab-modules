variable "applications" {
  description = "A map of applications"
  type = map(object({
    redirect_url = string
    scopes       = set(string)
    confidential = optional(bool, true)
  }))
  default = {}
}

variable "applications_file" {
  description = "Path to YAML file containing applications"
  type        = string
  default     = null
}
