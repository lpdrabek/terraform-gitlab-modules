locals {
  yaml_raw = try(yamldecode(file(var.groups_file)), {})

  groups_from_file = {
    for group_name, config in local.yaml_raw :
    group_name => {
      path             = try(tostring(config.path), null)
      description      = try(tostring(config.description), null)
      parent_id        = try(tonumber(config.parent_id), null)
      visibility_level = try(tostring(config.visibility_level), "private")
      default_branch   = try(tostring(config.default_branch), null)
      default_branch_protection_defaults = try(config.default_branch_protection_defaults, null) != null ? {
        allowed_to_push            = try(tolist(config.default_branch_protection_defaults.allowed_to_push), null)
        allow_force_push           = try(tobool(config.default_branch_protection_defaults.allow_force_push), null)
        allowed_to_merge           = try(tolist(config.default_branch_protection_defaults.allowed_to_merge), null)
        developer_can_initial_push = try(tobool(config.default_branch_protection_defaults.developer_can_initial_push), null)
      } : null
      project_creation_level             = try(tostring(config.project_creation_level), null)
      subgroup_creation_level            = try(tostring(config.subgroup_creation_level), null)
      membership_lock                    = try(tobool(config.membership_lock), null)
      share_with_group_lock              = try(tobool(config.share_with_group_lock), null)
      request_access_enabled             = try(tobool(config.request_access_enabled), true)
      prevent_forking_outside_group      = try(tobool(config.prevent_forking_outside_group), false)
      auto_devops_enabled                = try(tobool(config.auto_devops_enabled), null)
      lfs_enabled                        = try(tobool(config.lfs_enabled), true)
      emails_enabled                     = try(tobool(config.emails_enabled), true)
      mentions_disabled                  = try(tobool(config.mentions_disabled), false)
      wiki_access_level                  = try(tostring(config.wiki_access_level), null)
      require_two_factor_authentication  = try(tobool(config.require_two_factor_authentication), false)
      two_factor_grace_period            = try(tonumber(config.two_factor_grace_period), 48)
      ip_restriction_ranges              = try(tolist(config.ip_restriction_ranges), null)
      allowed_email_domains_list         = try(tolist(config.allowed_email_domains_list), null)
      shared_runners_setting             = try(tostring(config.shared_runners_setting), null)
      shared_runners_minutes_limit       = try(tonumber(config.shared_runners_minutes_limit), null)
      extra_shared_runners_minutes_limit = try(tonumber(config.extra_shared_runners_minutes_limit), null)
      push_rules = try(config.push_rules, null) != null ? {
        author_email_regex            = try(tostring(config.push_rules.author_email_regex), null)
        branch_name_regex             = try(tostring(config.push_rules.branch_name_regex), null)
        commit_message_regex          = try(tostring(config.push_rules.commit_message_regex), null)
        commit_message_negative_regex = try(tostring(config.push_rules.commit_message_negative_regex), null)
        file_name_regex               = try(tostring(config.push_rules.file_name_regex), null)
        deny_delete_tag               = try(tobool(config.push_rules.deny_delete_tag), null)
        member_check                  = try(tobool(config.push_rules.member_check), null)
        prevent_secrets               = try(tobool(config.push_rules.prevent_secrets), null)
        reject_unsigned_commits       = try(tobool(config.push_rules.reject_unsigned_commits), null)
        max_file_size                 = try(tonumber(config.push_rules.max_file_size), null)
        commit_committer_check        = try(tobool(config.push_rules.commit_committer_check), null)
        commit_committer_name_check   = try(tobool(config.push_rules.commit_committer_name_check), null)
      } : null
      avatar                       = try(tostring(config.avatar), null)
      avatar_hash                  = try(tostring(config.avatar_hash), null)
      permanently_remove_on_delete = try(tobool(config.permanently_remove_on_delete), false)
      projects                     = try(config.projects, {})
    }
  }

  groups_from_var = {
    for group_name, config in var.groups :
    group_name => {
      path             = config.path
      description      = config.description
      parent_id        = config.parent_id
      visibility_level = coalesce(config.visibility_level, "private")
      default_branch   = config.default_branch
      default_branch_protection_defaults = config.default_branch_protection_defaults != null ? {
        allowed_to_push            = config.default_branch_protection_defaults.allowed_to_push
        allow_force_push           = config.default_branch_protection_defaults.allow_force_push
        allowed_to_merge           = config.default_branch_protection_defaults.allowed_to_merge
        developer_can_initial_push = config.default_branch_protection_defaults.developer_can_initial_push
      } : null
      project_creation_level             = config.project_creation_level
      subgroup_creation_level            = config.subgroup_creation_level
      membership_lock                    = config.membership_lock
      share_with_group_lock              = config.share_with_group_lock
      request_access_enabled             = coalesce(config.request_access_enabled, true)
      prevent_forking_outside_group      = coalesce(config.prevent_forking_outside_group, false)
      auto_devops_enabled                = config.auto_devops_enabled
      lfs_enabled                        = coalesce(config.lfs_enabled, true)
      emails_enabled                     = coalesce(config.emails_enabled, true)
      mentions_disabled                  = coalesce(config.mentions_disabled, false)
      wiki_access_level                  = config.wiki_access_level
      require_two_factor_authentication  = coalesce(config.require_two_factor_authentication, false)
      two_factor_grace_period            = coalesce(config.two_factor_grace_period, 48)
      ip_restriction_ranges              = config.ip_restriction_ranges
      allowed_email_domains_list         = config.allowed_email_domains_list
      shared_runners_setting             = config.shared_runners_setting
      shared_runners_minutes_limit       = config.shared_runners_minutes_limit
      extra_shared_runners_minutes_limit = config.extra_shared_runners_minutes_limit
      push_rules = config.push_rules != null ? {
        author_email_regex            = config.push_rules.author_email_regex
        branch_name_regex             = config.push_rules.branch_name_regex
        commit_message_regex          = config.push_rules.commit_message_regex
        commit_message_negative_regex = config.push_rules.commit_message_negative_regex
        file_name_regex               = config.push_rules.file_name_regex
        deny_delete_tag               = config.push_rules.deny_delete_tag
        member_check                  = config.push_rules.member_check
        prevent_secrets               = config.push_rules.prevent_secrets
        reject_unsigned_commits       = config.push_rules.reject_unsigned_commits
        max_file_size                 = config.push_rules.max_file_size
        commit_committer_check        = config.push_rules.commit_committer_check
        commit_committer_name_check   = config.push_rules.commit_committer_name_check
      } : null
      avatar                       = config.avatar
      avatar_hash                  = config.avatar_hash
      permanently_remove_on_delete = coalesce(config.permanently_remove_on_delete, false)
      projects                     = coalesce(config.projects, {})
    }
  }

  all_groups = merge(local.groups_from_file, local.groups_from_var)

  all_projects = merge([
    for group_name, group in local.all_groups : {
      for project_name, project in group.projects :
      "${group_name}/${project_name}" => {
        group_name                                       = group_name
        description                                      = try(project.description, null)
        path                                             = try(project.path, null)
        visibility_level                                 = try(project.visibility_level, "private")
        default_branch                                   = try(project.default_branch, null)
        initialize_with_readme                           = try(project.initialize_with_readme, false)
        topics                                           = try(toset(project.topics), [])
        issues_access_level                              = try(project.issues_access_level, "enabled")
        merge_requests_access_level                      = try(project.merge_requests_access_level, "enabled")
        wiki_access_level                                = try(project.wiki_access_level, "enabled")
        builds_access_level                              = try(project.builds_access_level, "enabled")
        snippets_access_level                            = try(project.snippets_access_level, "enabled")
        shared_runners_enabled                           = try(project.shared_runners_enabled, true)
        ci_config_path                                   = try(project.ci_config_path, null)
        merge_method                                     = try(project.merge_method, "merge")
        squash_option                                    = try(project.squash_option, "default_off")
        remove_source_branch_after_merge                 = try(project.remove_source_branch_after_merge, false)
        only_allow_merge_if_pipeline_succeeds            = try(project.only_allow_merge_if_pipeline_succeeds, false)
        only_allow_merge_if_all_discussions_are_resolved = try(project.only_allow_merge_if_all_discussions_are_resolved, false)
        push_rules = try(project.push_rules, null) != null ? {
          author_email_regex            = try(project.push_rules.author_email_regex, null)
          branch_name_regex             = try(project.push_rules.branch_name_regex, null)
          commit_message_regex          = try(project.push_rules.commit_message_regex, null)
          commit_message_negative_regex = try(project.push_rules.commit_message_negative_regex, null)
          file_name_regex               = try(project.push_rules.file_name_regex, null)
          deny_delete_tag               = try(project.push_rules.deny_delete_tag, null)
          member_check                  = try(project.push_rules.member_check, null)
          prevent_secrets               = try(project.push_rules.prevent_secrets, null)
          reject_unsigned_commits       = try(project.push_rules.reject_unsigned_commits, null)
          max_file_size                 = try(project.push_rules.max_file_size, null)
        } : null
        labels                 = try(project.labels, {})
        labels_file            = try(project.labels_file, null)
        labels_create_only     = try(project.labels_create_only, false)
        milestones             = try(project.milestones, {})
        milestones_file        = try(project.milestones_file, null)
        milestones_create_only = try(project.milestones_create_only, false)
        badges                 = try(project.badges, {})
        badges_file            = try(project.badges_file, null)
        badges_create_only     = try(project.badges_create_only, false)
        issues                 = try(project.issues, {})
        issues_file            = try(project.issues_file, null)
        issues_create_only     = try(project.issues_create_only, false)
      }
    }
  ]...)
}
