variable "project" {
  description = "Project ID or path to apply tag protection to"
  type        = string
}

variable "tags" {
  description = "Map of tags and their protection settings. Map key is used as the tag pattern (supports wildcards like v*)."
  type = map(object({
    # Lookup method for users/groups
    # For users: email, username, userid
    # For groups: groupid, fullpath
    search_by = optional(string, "email")

    # Access level for creating tags: no one, developer, maintainer
    create_access_level = optional(string)

    # Users allowed to create (list of emails, usernames, or user IDs based on search_by)
    # Premium/Ultimate only
    allowed_to_create = optional(list(string), [])

    # Groups allowed to create (list of group IDs or full paths based on search_by)
    # Premium/Ultimate only
    groups_allowed_to_create = optional(list(string), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for tag, config in var.tags :
      config.search_by == null || contains(["email", "username", "userid", "groupid", "fullpath"], config.search_by)
    ])
    error_message = "search_by must be one of: email, username, userid, groupid, fullpath"
  }

  validation {
    condition = alltrue([
      for tag, config in var.tags :
      config.create_access_level == null ||
      contains(["no one", "developer", "maintainer"], config.create_access_level)
    ])
    error_message = "create_access_level must be one of: no one, developer, maintainer"
  }
}

variable "tags_file" {
  description = "Path to YAML file containing tag protection configuration. Merged with tags variable."
  type        = string
  default     = null
}

variable "create_only" {
  description = "If true, tag protections will only be created and ignore attribute changes after creation"
  type        = bool
  default     = false
}
