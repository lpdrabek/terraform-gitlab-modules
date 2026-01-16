resource "gitlab_group" "groups" {
  for_each = { for name, config in local.all_groups : name => config if !var.create_only }

  name                               = each.key
  path                               = coalesce(each.value.path, each.key)
  description                        = each.value.description
  parent_id                          = each.value.parent_id
  visibility_level                   = each.value.visibility_level
  default_branch                     = each.value.default_branch
  avatar                             = each.value.avatar
  avatar_hash                        = each.value.avatar_hash
  permanently_remove_on_delete       = each.value.permanently_remove_on_delete
  project_creation_level             = each.value.project_creation_level
  subgroup_creation_level            = each.value.subgroup_creation_level
  membership_lock                    = each.value.membership_lock
  share_with_group_lock              = each.value.share_with_group_lock
  request_access_enabled             = each.value.request_access_enabled
  prevent_forking_outside_group      = each.value.prevent_forking_outside_group
  auto_devops_enabled                = each.value.auto_devops_enabled
  lfs_enabled                        = each.value.lfs_enabled
  emails_enabled                     = each.value.emails_enabled
  mentions_disabled                  = each.value.mentions_disabled
  wiki_access_level                  = each.value.wiki_access_level
  require_two_factor_authentication  = each.value.require_two_factor_authentication
  two_factor_grace_period            = each.value.two_factor_grace_period
  ip_restriction_ranges              = each.value.ip_restriction_ranges
  allowed_email_domains_list         = each.value.allowed_email_domains_list
  shared_runners_setting             = each.value.shared_runners_setting
  shared_runners_minutes_limit       = each.value.shared_runners_minutes_limit
  extra_shared_runners_minutes_limit = each.value.extra_shared_runners_minutes_limit


  dynamic "default_branch_protection_defaults" {
    for_each = each.value.default_branch_protection_defaults != null ? [each.value.default_branch_protection_defaults] : []
    content {
      allowed_to_push            = default_branch_protection_defaults.value.allowed_to_push
      allow_force_push           = default_branch_protection_defaults.value.allow_force_push
      allowed_to_merge           = default_branch_protection_defaults.value.allowed_to_merge
      developer_can_initial_push = default_branch_protection_defaults.value.developer_can_initial_push
    }
  }
  dynamic "push_rules" {
    for_each = each.value.push_rules != null ? [each.value.push_rules] : []
    content {
      author_email_regex            = push_rules.value.author_email_regex
      branch_name_regex             = push_rules.value.branch_name_regex
      commit_message_regex          = push_rules.value.commit_message_regex
      commit_message_negative_regex = push_rules.value.commit_message_negative_regex
      file_name_regex               = push_rules.value.file_name_regex
      deny_delete_tag               = push_rules.value.deny_delete_tag
      member_check                  = push_rules.value.member_check
      prevent_secrets               = push_rules.value.prevent_secrets
      reject_unsigned_commits       = push_rules.value.reject_unsigned_commits
      max_file_size                 = push_rules.value.max_file_size
      commit_committer_check        = push_rules.value.commit_committer_check
      commit_committer_name_check   = push_rules.value.commit_committer_name_check
    }
  }
}

resource "gitlab_group" "create_only_groups" {
  for_each = { for name, config in local.all_groups : name => config if var.create_only }

  name                               = each.key
  path                               = coalesce(each.value.path, each.key)
  description                        = each.value.description
  parent_id                          = each.value.parent_id
  visibility_level                   = each.value.visibility_level
  default_branch                     = each.value.default_branch
  avatar                             = each.value.avatar
  avatar_hash                        = each.value.avatar_hash
  permanently_remove_on_delete       = each.value.permanently_remove_on_delete
  project_creation_level             = each.value.project_creation_level
  subgroup_creation_level            = each.value.subgroup_creation_level
  membership_lock                    = each.value.membership_lock
  share_with_group_lock              = each.value.share_with_group_lock
  request_access_enabled             = each.value.request_access_enabled
  prevent_forking_outside_group      = each.value.prevent_forking_outside_group
  auto_devops_enabled                = each.value.auto_devops_enabled
  lfs_enabled                        = each.value.lfs_enabled
  emails_enabled                     = each.value.emails_enabled
  mentions_disabled                  = each.value.mentions_disabled
  wiki_access_level                  = each.value.wiki_access_level
  require_two_factor_authentication  = each.value.require_two_factor_authentication
  two_factor_grace_period            = each.value.two_factor_grace_period
  ip_restriction_ranges              = each.value.ip_restriction_ranges
  allowed_email_domains_list         = each.value.allowed_email_domains_list
  shared_runners_setting             = each.value.shared_runners_setting
  shared_runners_minutes_limit       = each.value.shared_runners_minutes_limit
  extra_shared_runners_minutes_limit = each.value.extra_shared_runners_minutes_limit


  dynamic "default_branch_protection_defaults" {
    for_each = each.value.default_branch_protection_defaults != null ? [each.value.default_branch_protection_defaults] : []
    content {
      allowed_to_push            = default_branch_protection_defaults.value.allowed_to_push
      allow_force_push           = default_branch_protection_defaults.value.allow_force_push
      allowed_to_merge           = default_branch_protection_defaults.value.allowed_to_merge
      developer_can_initial_push = default_branch_protection_defaults.value.developer_can_initial_push
    }
  }
  dynamic "push_rules" {
    for_each = each.value.push_rules != null ? [each.value.push_rules] : []
    content {
      author_email_regex            = push_rules.value.author_email_regex
      branch_name_regex             = push_rules.value.branch_name_regex
      commit_message_regex          = push_rules.value.commit_message_regex
      commit_message_negative_regex = push_rules.value.commit_message_negative_regex
      file_name_regex               = push_rules.value.file_name_regex
      deny_delete_tag               = push_rules.value.deny_delete_tag
      member_check                  = push_rules.value.member_check
      prevent_secrets               = push_rules.value.prevent_secrets
      reject_unsigned_commits       = push_rules.value.reject_unsigned_commits
      max_file_size                 = push_rules.value.max_file_size
      commit_committer_check        = push_rules.value.commit_committer_check
      commit_committer_name_check   = push_rules.value.commit_committer_name_check
    }
  }

  lifecycle {
    ignore_changes = all
  }
}
