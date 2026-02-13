variable "project" {
  description = "The name or ID of the project"
  type        = string
}

variable "files" {
  description = "Map of repository files to create. Key is the file_path."
  type = map(object({
    branch                = string
    content               = string
    encoding              = optional(string, "text")
    author_email          = optional(string)
    author_name           = optional(string)
    commit_message        = optional(string)
    create_commit_message = optional(string)
    delete_commit_message = optional(string)
    update_commit_message = optional(string)
    execute_filemode      = optional(bool)
    overwrite_on_create   = optional(bool)
    start_branch          = optional(string)
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for path, f in var.files :
      !startswith(path, "/") && !startswith(path, "./")
    ])
    error_message = "file_path (map key) must be relative to the root of the project without a leading slash / or ./"
  }

  validation {
    condition = alltrue([
      for f in var.files :
      contains(["base64", "text"], f.encoding)
    ])
    error_message = "encoding must be either 'base64' or 'text'"
  }

  validation {
    condition = alltrue([
      for f in var.files :
      (f.create_commit_message == null && f.update_commit_message == null && f.delete_commit_message == null) ||
      (f.create_commit_message != null && f.update_commit_message != null && f.delete_commit_message != null)
    ])
    error_message = "create_commit_message, update_commit_message, and delete_commit_message must all be specified together or none at all"
  }

  validation {
    condition = alltrue([
      for f in var.files :
      (f.author_name == null && f.author_email == null) ||
      (f.author_name != null && f.author_email != null)
    ])
    error_message = "author_name and author_email must both be specified together or none at all"
  }

  validation {
    condition = alltrue([
      for f in var.files :
      f.author_email == null || can(regex("^[^@]+@[^@]+\\.[^@]+$", f.author_email))
    ])
    error_message = "author_email must be a valid email address"
  }
}

variable "files_file" {
  description = "Path to YAML file containing repository files configuration. Merged with files variable."
  type        = string
  default     = null
}
