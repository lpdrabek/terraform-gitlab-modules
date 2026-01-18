variable "projects" {
  description = "Map of GitLab projects to create. Map key is used as the project name."
  type = map(object({
    # Core Settings
    description      = optional(string)
    namespace_id     = optional(number)
    path             = optional(string)
    visibility_level = optional(string, "private")
    default_branch   = optional(string)

    # Repository Configuration
    import_url             = optional(string)
    import_url_username    = optional(string)
    import_url_password    = optional(string, null)
    mirror                 = optional(bool)
    forked_from_project_id = optional(number)
    initialize_with_readme = optional(bool, false)
    mr_default_target_self = optional(bool)

    # Templates
    use_custom_template             = optional(bool, false)
    template_name                   = optional(string)
    template_project_id             = optional(number)
    group_with_project_templates_id = optional(number)

    # Access Control - Features
    issues_access_level                  = optional(string, "enabled")
    merge_requests_access_level          = optional(string, "enabled")
    wiki_access_level                    = optional(string, "enabled")
    builds_access_level                  = optional(string, "enabled")
    snippets_access_level                = optional(string, "enabled")
    repository_access_level              = optional(string, "enabled")
    pages_access_level                   = optional(string, "private")
    analytics_access_level               = optional(string, "enabled")
    requirements_access_level            = optional(string, "enabled")
    environments_access_level            = optional(string, "enabled")
    feature_flags_access_level           = optional(string, "enabled")
    infrastructure_access_level          = optional(string, "enabled")
    monitor_access_level                 = optional(string, "enabled")
    releases_access_level                = optional(string, "enabled")
    security_and_compliance_access_level = optional(string, "private")
    container_registry_access_level      = optional(string, "enabled")
    model_experiments_access_level       = optional(string, "enabled")
    model_registry_access_level          = optional(string, "enabled")

    # CI/CD Settings
    ci_config_path                              = optional(string)
    ci_default_git_depth                        = optional(number)
    ci_pipeline_variables_minimum_override_role = optional(string)
    auto_devops_enabled                         = optional(bool)
    auto_devops_deploy_strategy                 = optional(string)
    build_timeout                               = optional(number, 3600)
    build_git_strategy                          = optional(string, "fetch")
    auto_cancel_pending_pipelines               = optional(string, "enabled")
    ci_forward_deployment_enabled               = optional(bool)
    ci_separated_caches                         = optional(bool, true)
    public_jobs                                 = optional(bool, true)
    shared_runners_enabled                      = optional(bool, true)
    group_runners_enabled                       = optional(bool, true)
    keep_latest_artifact                        = optional(bool, true)

    # Merge Request Settings
    only_allow_merge_if_pipeline_succeeds            = optional(bool, false)
    only_allow_merge_if_all_discussions_are_resolved = optional(bool, false)
    merge_method                                     = optional(string, "merge")
    merge_pipelines_enabled                          = optional(bool, false)
    merge_trains_enabled                             = optional(bool, false)
    remove_source_branch_after_merge                 = optional(bool, false)
    merge_commit_template                            = optional(string)
    squash_option                                    = optional(string, "default_off")
    squash_commit_template                           = optional(string)
    resolve_outdated_diff_discussions                = optional(bool, false)
    printing_merge_request_link_enabled              = optional(bool, true)
    merge_requests_template                          = optional(string)

    # Protection & Security
    archived                             = optional(bool, false)
    archive_on_destroy                   = optional(bool, false)
    lfs_enabled                          = optional(bool, true)
    pre_receive_secret_detection_enabled = optional(bool, false)

    # Push Rules
    push_rules = optional(object({
      author_email_regex            = optional(string)
      branch_name_regex             = optional(string)
      commit_message_regex          = optional(string)
      commit_message_negative_regex = optional(string)
      file_name_regex               = optional(string)
      deny_delete_tag               = optional(bool)
      member_check                  = optional(bool)
      prevent_secrets               = optional(bool)
      reject_unsigned_commits       = optional(bool)
      max_file_size                 = optional(number)
      commit_committer_check        = optional(bool)
      commit_committer_name_check   = optional(bool)
    }))

    # Additional Features
    avatar                                  = optional(string)
    avatar_hash                             = optional(string)
    topics                                  = optional(set(string), [])
    request_access_enabled                  = optional(bool, true)
    emails_enabled                          = optional(bool, true)
    autoclose_referenced_issues             = optional(bool, true)
    issues_template                         = optional(string)
    suggestion_commit_message               = optional(string)
    packages_enabled                        = optional(bool)
    skip_wait_for_default_branch_protection = optional(bool, false)
    auto_duo_code_review_enabled            = optional(bool, false)

    # Container Expiration Policy
    container_expiration_policy = optional(object({
      cadence           = optional(string)
      enabled           = optional(bool)
      keep_n            = optional(number)
      older_than        = optional(string)
      name_regex_delete = optional(string)
      name_regex_keep   = optional(string)
    }))

    # Milestones (inline or via file)
    milestones = optional(map(object({
      description = optional(string)
      state       = optional(string)
      start_date  = optional(string)
      due_date    = optional(string)
    })), {})
    milestones_file        = optional(string)
    milestones_create_only = optional(bool, false)

    # Labels (inline or via file)
    labels = optional(map(object({
      color       = optional(string)
      description = optional(string)
    })), {})
    labels_file        = optional(string)
    labels_create_only = optional(bool, false)

    # Badges (inline or via file)
    badges = optional(map(object({
      link_url  = string
      image_url = string
    })), {})
    badges_file        = optional(string)
    badges_create_only = optional(bool, false)

    # Issues (inline or via file)
    issues = optional(map(object({
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
      epic_issue_id                            = optional(number)
      issue_type                               = optional(string)
      state                                    = optional(string)
      confidential                             = optional(bool)
      weight                                   = optional(number)
      due_date                                 = optional(string)
      created_at                               = optional(string)
      updated_at                               = optional(string)
      discussion_locked                        = optional(bool)
      discussion_to_resolve                    = optional(string)
      delete_on_destroy                        = optional(bool)
      merge_request_to_resolve_discussions_of = optional(number)
    })), {})
    issues_file        = optional(string)
    issues_create_only = optional(bool, false)

    # Push Mirror - replicate this project to an external repository
    push_mirror = optional(object({
      url                     = string               # URL of the remote repository to push to
      auth_method             = optional(string)     # Authentication method: ssh_public_key, password
      enabled                 = optional(bool, true) # Whether the mirror is enabled
      keep_divergent_refs     = optional(bool)       # Skip divergent refs instead of failing
      only_protected_branches = optional(bool)       # Only mirror protected branches
      mirror_branch_regex     = optional(string)     # Regex for branches to mirror (Premium/Ultimate)
    }))

    # Pull Mirror - sync from an external repository into this project
    pull_mirror = optional(object({
      url                                 = string               # URL of the remote repository to pull from
      auth_user                           = optional(string)     # Username for authentication
      auth_password                       = optional(string)     # Password or token for authentication
      enabled                             = optional(bool, true) # Whether the mirror is enabled
      mirror_overwrites_diverged_branches = optional(bool)       # Overwrite diverged branches
      mirror_trigger_builds               = optional(bool)       # Trigger pipelines when mirror updates
      only_mirror_protected_branches      = optional(bool)       # Only mirror protected branches
      mirror_branch_regex                 = optional(string)     # Regex for branches to mirror (Premium/Ultimate)
    }))
  }))
  default = {}

  # Validations
  validation {
    condition = alltrue([
      for key, project in var.projects :
      project.visibility_level == null || contains(["private", "internal", "public"], project.visibility_level)
    ])
    error_message = "visibility_level must be one of: private, internal, public"
  }

  validation {
    condition = alltrue([
      for key, project in var.projects :
      project.merge_method == null || contains(["merge", "rebase_merge", "ff"], project.merge_method)
    ])
    error_message = "merge_method must be one of: merge, rebase_merge, ff"
  }

  validation {
    condition = alltrue([
      for key, project in var.projects :
      project.squash_option == null || contains(["never", "always", "default_on", "default_off"], project.squash_option)
    ])
    error_message = "squash_option must be one of: never, always, default_on, default_off"
  }

  validation {
    condition = alltrue([
      for key, project in var.projects :
      project.auto_cancel_pending_pipelines == null || contains(["enabled", "disabled"], project.auto_cancel_pending_pipelines)
    ])
    error_message = "auto_cancel_pending_pipelines must be one of: enabled, disabled"
  }

  validation {
    condition = alltrue([
      for key, project in var.projects :
      project.build_git_strategy == null || contains(["clone", "fetch"], project.build_git_strategy)
    ])
    error_message = "build_git_strategy must be one of: clone, fetch"
  }

  validation {
    condition = alltrue([
      for key, project in var.projects :
      project.auto_devops_deploy_strategy == null || contains(["continuous", "manual", "timed_incremental"], project.auto_devops_deploy_strategy)
    ])
    error_message = "auto_devops_deploy_strategy must be one of: continuous, manual, timed_incremental"
  }

  validation {
    condition = alltrue([
      for key, project in var.projects :
      project.ci_pipeline_variables_minimum_override_role == null ||
      contains(["developer", "maintainer", "owner", "no_one_allowed"], project.ci_pipeline_variables_minimum_override_role)
    ])
    error_message = "ci_pipeline_variables_minimum_override_role must be one of: developer, maintainer, owner, no_one_allowed"
  }
}

variable "projects_file" {
  description = "Path to YAML file containing projects. Merged with projects variable."
  type        = string
  default     = null
}

variable "create_only" {
  description = "If set to true, projects will only be created and ignore attribute changes after creation"
  type        = bool
  default     = false
}
