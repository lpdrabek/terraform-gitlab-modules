variable "project_id" {
  description = "ID of the project the issues are assigned to"
  type        = string
}

variable "issues" {
  description = "Map of issues to create in the project"
  type = map(object({
    title        = string
    description  = optional(string)
    assignee_ids = optional(set(number))
    labels = optional(map(object({
      color       = optional(string)
      description = optional(string)
    })))
    milestone = optional(map(object({
      description = optional(string)
      state       = optional(string)
      start_date  = optional(string)
      due_date    = optional(string)
    })))
    epic_issue_id         = optional(number)
    issue_type            = optional(string)
    state                 = optional(string)
    confidential          = optional(bool)
    weight                = optional(number)
    due_date              = optional(string)
    created_at            = optional(string)
    updated_at            = optional(string)
    discussion_locked     = optional(bool)
    discussion_to_resolve = optional(string)
    delete_on_destroy     = optional(bool)

    merge_request_to_resolve_discussions_of = optional(number)
  }))

  default = {}

  validation {
    condition = alltrue([
      for key, issue in var.issues :
      issue.issue_type == null || contains(["issue", "incident", "test_case"], issue.issue_type)
    ])
    error_message = "issue_type must be one of: issue, incident, test_case"
  }

  validation {
    condition = alltrue([
      for key, issue in var.issues :
      issue.state == null || contains(["opened", "closed"], issue.state)
    ])
    error_message = "state must be one of: opened, closed"
  }

  validation {
    condition = alltrue([
      for key, issue in var.issues :
      issue.weight == null || (issue.weight >= 0 && floor(issue.weight) == issue.weight)
    ])
    error_message = "weight must be a non-negative integer (>= 0)"
  }

  validation {
    condition = alltrue([
      for key, issue in var.issues :
      issue.due_date == null || can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", issue.due_date))
    ])
    error_message = "due_date must be in YYYY-MM-DD format (e.g., 2026-01-15)"
  }

  validation {
    condition = alltrue([
      for key, issue in var.issues :
      issue.description == null || length(issue.description) <= 1048576
    ])
    error_message = "description must not exceed 1,048,576 characters"
  }
}

variable "issues_file" {
  type    = string
  default = null
}

variable "create_only" {
  description = "If set to true, module will only create the issues and ignore other attributes after creation"
  type        = bool
  default     = false
}

variable "create_milestones" {
  description = "If set to false, module will not create milestones (assumes they already exist)."
  type        = bool
  default     = true
}

variable "create_labels" {
  description = "If set to false, module will not create labels (assumes they already exist)."
  type        = bool
  default     = true
}
