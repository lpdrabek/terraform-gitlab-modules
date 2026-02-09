variable "groups" {
  description = "Map of GitLab groups to create. Map key is used as the group nmae."
  type = map(object({
    path             = optional(string)
    description      = optional(string)
    parent_id        = optional(number)
    visibility_level = optional(string, "private")
    default_branch   = optional(string)
    default_branch_protection_defaults = optional(object({
      allowed_to_push            = optional(list(string))
      allow_force_push           = optional(bool)
      allowed_to_merge           = optional(list(string))
      developer_can_initial_push = optional(bool)
    }))
    project_creation_level             = optional(string)
    subgroup_creation_level            = optional(string)
    membership_lock                    = optional(bool)
    share_with_group_lock              = optional(bool)
    request_access_enabled             = optional(bool, true)
    prevent_forking_outside_group      = optional(bool, false)
    auto_devops_enabled                = optional(bool)
    lfs_enabled                        = optional(bool, true)
    emails_enabled                     = optional(bool, true)
    mentions_disabled                  = optional(bool, false)
    wiki_access_level                  = optional(string) # Premium/Ultimate only
    require_two_factor_authentication  = optional(bool, false)
    two_factor_grace_period            = optional(number, 48)
    ip_restriction_ranges              = optional(list(string))
    allowed_email_domains_list         = optional(list(string))
    shared_runners_setting             = optional(string)
    shared_runners_minutes_limit       = optional(number)
    extra_shared_runners_minutes_limit = optional(number)
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
    avatar                       = optional(string)
    avatar_hash                  = optional(string)
    permanently_remove_on_delete = optional(bool, false)

    # Deploy Tokens (group-level)
    deploy_tokens = optional(map(object({
      scopes                        = list(string)
      username                      = optional(string)
      expires_at                    = optional(string)
      validate_past_expiration_date = optional(bool)
    })), {})
    deploy_tokens_file        = optional(string)
    deploy_tokens_create_only = optional(bool, false)

    # Projects to create inside this group
    projects = optional(map(object({
      description            = optional(string)
      path                   = optional(string)
      visibility_level       = optional(string, "private")
      default_branch         = optional(string)
      initialize_with_readme = optional(bool, false)
      topics                 = optional(set(string), [])

      # Features
      issues_access_level         = optional(string, "enabled")
      merge_requests_access_level = optional(string, "enabled")
      wiki_access_level           = optional(string, "enabled")
      builds_access_level         = optional(string, "enabled")
      snippets_access_level       = optional(string, "enabled")

      # CI/CD
      shared_runners_enabled = optional(bool, true)
      ci_config_path         = optional(string)

      # Merge settings
      merge_method                                     = optional(string, "merge")
      squash_option                                    = optional(string, "default_off")
      remove_source_branch_after_merge                 = optional(bool, false)
      only_allow_merge_if_pipeline_succeeds            = optional(bool, false)
      only_allow_merge_if_all_discussions_are_resolved = optional(bool, false)

      # Push rules
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
      }))

      # Labels
      labels = optional(map(object({
        color       = optional(string)
        description = optional(string)
      })), {})
      labels_file        = optional(string)
      labels_create_only = optional(bool, false)

      # Milestones
      milestones = optional(map(object({
        description = optional(string)
        state       = optional(string)
        start_date  = optional(string)
        due_date    = optional(string)
      })), {})
      milestones_file        = optional(string)
      milestones_create_only = optional(bool, false)

      # Badges
      badges = optional(map(object({
        link_url  = string
        image_url = string
      })), {})
      badges_file        = optional(string)
      badges_create_only = optional(bool, false)

      # Issues
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
        issue_type   = optional(string)
        state        = optional(string)
        confidential = optional(bool)
        weight       = optional(number)
        due_date     = optional(string)
      })), {})
      issues_file        = optional(string)
      issues_create_only = optional(bool, false)

      # Deploy Tokens (project-level)
      deploy_tokens = optional(map(object({
        scopes                        = list(string)
        username                      = optional(string)
        expires_at                    = optional(string)
        validate_past_expiration_date = optional(bool)
      })), {})
      deploy_tokens_file        = optional(string)
      deploy_tokens_create_only = optional(bool, false)
    })), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for key, group in var.groups :
      group.visibility_level == null || contains(["private", "internal", "public"], group.visibility_level)
    ])
    error_message = "visibility_level must be one of: private, internal, public"
  }

  validation {
    condition = alltrue([
      for key, group in var.groups :
      group.project_creation_level == null || contains(["noone", "owner", "maintainer", "developer"], group.project_creation_level)
    ])
    error_message = "project_creation_level must be one of: noone, owner, maintainer, developer"
  }

  validation {
    condition = alltrue([
      for key, group in var.groups :
      group.subgroup_creation_level == null || contains(["owner", "maintainer"], group.subgroup_creation_level)
    ])
    error_message = "subgroup_creation_level must be one of: owner, maintainer"
  }

  validation {
    condition = alltrue([
      for key, group in var.groups :
      group.shared_runners_setting == null || contains(["enabled", "disabled_and_overridable", "disabled_and_unoverridable", "disabled_with_override"], group.shared_runners_setting)
    ])
    error_message = "shared_runners_setting must be one of: enabled, disabled_and_overridable, disabled_and_unoverridable, disabled_with_override"
  }

  validation {
    condition = alltrue([
      for key, group in var.groups :
      group.wiki_access_level == null || contains(["disabled", "private", "enabled"], group.wiki_access_level)
    ])
    error_message = "wiki_access_level must be one of: disabled, private, enabled"
  }
}

variable "groups_file" {
  description = "Path to YAML file containing groups. Merged with groups variable."
  type        = string
  default     = null
}

variable "create_only" {
  description = "If set to true, groups will only be created and ignore attribute changes after creation"
  type        = bool
  default     = false
}
