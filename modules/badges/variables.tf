variable "target" {
  description = "Target for badges. Accepts \"project\" or \"group\""
  type = object({
    type = string # "project" or "group"
    id   = string
  })

  validation {
    condition     = contains(["project", "group"], var.target.type)
    error_message = "Target type must be either 'project' or 'group'"
  }
}

variable "badges" {
  description = "A map of badges and their properties"
  type = map(object({
    link_url  = string
    image_url = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for key, badge in var.badges :
      can(regex("^https?://", badge.link_url))
    ])
    error_message = "link_url must use http:// or https:// scheme"
  }

  validation {
    condition = alltrue([
      for key, badge in var.badges :
      can(regex("^https?://", badge.image_url))
    ])
    error_message = "image_url must use http:// or https:// scheme"
  }

  validation {
    condition = alltrue([
      for key, badge in var.badges :
      can(regex("^https?://.+\\.(svg|png|jpg|jpeg|gif)$", badge.image_url))
    ])
    error_message = "image_url must point to a valid image file (svg, png, jpg, jpeg, or gif)"
  }
}

variable "badges_file" {
  description = "Path to YAML file containing badges"
  type        = string
  default     = null
}
