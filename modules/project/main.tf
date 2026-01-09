resource "gitlab_project" "projects" {
  for_each = { for k, v in local.all_projects : k => v if !var.create_only }

  # Required
  name = each.key

  # Core Settings
  description      = each.value.description
  namespace_id     = each.value.namespace_id
  path             = each.value.path
  visibility_level = each.value.visibility_level
  default_branch   = each.value.default_branch

  # Repository Configuration
  import_url                      = each.value.import_url
  import_url_username             = each.value.import_url_username
  import_url_password             = each.value.import_url_password
  mirror                          = each.value.import_url != null ? each.value.mirror : null
  forked_from_project_id          = each.value.forked_from_project_id
  initialize_with_readme          = each.value.initialize_with_readme
  mr_default_target_self          = each.value.forked_from_project_id != null ? each.value.mr_default_target_self : null
  use_custom_template             = each.value.use_custom_template
  template_name                   = each.value.template_name
  template_project_id             = each.value.template_project_id
  group_with_project_templates_id = each.value.group_with_project_templates_id

  # Access Control - Features
  issues_access_level                  = each.value.issues_access_level
  merge_requests_access_level          = each.value.merge_requests_access_level
  wiki_access_level                    = each.value.wiki_access_level
  builds_access_level                  = each.value.builds_access_level
  snippets_access_level                = each.value.snippets_access_level
  repository_access_level              = each.value.repository_access_level
  pages_access_level                   = each.value.pages_access_level
  analytics_access_level               = each.value.analytics_access_level
  requirements_access_level            = each.value.requirements_access_level
  environments_access_level            = each.value.environments_access_level
  feature_flags_access_level           = each.value.feature_flags_access_level
  infrastructure_access_level          = each.value.infrastructure_access_level
  monitor_access_level                 = each.value.monitor_access_level
  releases_access_level                = each.value.releases_access_level
  security_and_compliance_access_level = each.value.security_and_compliance_access_level
  container_registry_access_level      = each.value.container_registry_access_level
  model_experiments_access_level       = each.value.model_experiments_access_level
  model_registry_access_level          = each.value.model_registry_access_level

  # CI/CD Settings
  ci_config_path                              = each.value.ci_config_path
  ci_default_git_depth                        = each.value.ci_default_git_depth
  ci_pipeline_variables_minimum_override_role = each.value.ci_pipeline_variables_minimum_override_role
  auto_devops_enabled                         = each.value.auto_devops_enabled
  auto_devops_deploy_strategy                 = each.value.auto_devops_deploy_strategy
  build_timeout                               = each.value.build_timeout
  build_git_strategy                          = each.value.build_git_strategy
  auto_cancel_pending_pipelines               = each.value.auto_cancel_pending_pipelines
  ci_forward_deployment_enabled               = each.value.ci_forward_deployment_enabled
  ci_separated_caches                         = each.value.ci_separated_caches
  public_jobs                                 = each.value.public_jobs
  shared_runners_enabled                      = each.value.shared_runners_enabled
  group_runners_enabled                       = each.value.group_runners_enabled
  keep_latest_artifact                        = each.value.keep_latest_artifact

  # Merge Request Settings
  only_allow_merge_if_pipeline_succeeds            = each.value.only_allow_merge_if_pipeline_succeeds
  only_allow_merge_if_all_discussions_are_resolved = each.value.only_allow_merge_if_all_discussions_are_resolved
  merge_method                                     = each.value.merge_method
  merge_pipelines_enabled                          = each.value.merge_pipelines_enabled
  merge_trains_enabled                             = each.value.merge_trains_enabled
  remove_source_branch_after_merge                 = each.value.remove_source_branch_after_merge
  merge_commit_template                            = each.value.merge_commit_template
  squash_option                                    = each.value.squash_option
  squash_commit_template                           = each.value.squash_commit_template
  resolve_outdated_diff_discussions                = each.value.resolve_outdated_diff_discussions
  printing_merge_request_link_enabled              = each.value.printing_merge_request_link_enabled
  merge_requests_template                          = each.value.merge_requests_template

  # Protection & Security
  archived                             = each.value.archived
  archive_on_destroy                   = each.value.archive_on_destroy
  lfs_enabled                          = each.value.lfs_enabled
  pre_receive_secret_detection_enabled = each.value.pre_receive_secret_detection_enabled

  # Push Rules
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

  # Additional Features
  avatar                                  = each.value.avatar
  avatar_hash                             = each.value.avatar_hash
  topics                                  = each.value.topics
  request_access_enabled                  = each.value.request_access_enabled
  emails_enabled                          = each.value.emails_enabled
  autoclose_referenced_issues             = each.value.autoclose_referenced_issues
  issues_template                         = each.value.issues_template
  suggestion_commit_message               = each.value.suggestion_commit_message
  packages_enabled                        = each.value.packages_enabled
  skip_wait_for_default_branch_protection = each.value.skip_wait_for_default_branch_protection
  auto_duo_code_review_enabled            = each.value.auto_duo_code_review_enabled

  # Container Expiration Policy
  dynamic "container_expiration_policy" {
    for_each = each.value.container_expiration_policy != null ? [each.value.container_expiration_policy] : []
    content {
      cadence           = container_expiration_policy.value.cadence
      enabled           = container_expiration_policy.value.enabled
      keep_n            = container_expiration_policy.value.keep_n
      older_than        = container_expiration_policy.value.older_than
      name_regex_delete = container_expiration_policy.value.name_regex_delete
      name_regex_keep   = container_expiration_policy.value.name_regex_keep
    }
  }
}

resource "gitlab_project" "create_only_projects" {
  for_each = { for k, v in local.all_projects : k => v if var.create_only }

  # Required
  name = each.key

  # Core Settings
  description      = each.value.description
  namespace_id     = each.value.namespace_id
  path             = each.value.path
  visibility_level = each.value.visibility_level
  default_branch   = each.value.default_branch

  # Repository Configuration
  import_url                      = each.value.import_url
  import_url_username             = each.value.import_url_username
  import_url_password             = each.value.import_url_password
  mirror                          = each.value.import_url != null ? each.value.mirror : null
  forked_from_project_id          = each.value.forked_from_project_id
  initialize_with_readme          = each.value.initialize_with_readme
  mr_default_target_self          = each.value.forked_from_project_id != null ? each.value.mr_default_target_self : null
  use_custom_template             = each.value.use_custom_template
  template_name                   = each.value.template_name
  template_project_id             = each.value.template_project_id
  group_with_project_templates_id = each.value.group_with_project_templates_id

  # Access Control - Features
  issues_access_level                  = each.value.issues_access_level
  merge_requests_access_level          = each.value.merge_requests_access_level
  wiki_access_level                    = each.value.wiki_access_level
  builds_access_level                  = each.value.builds_access_level
  snippets_access_level                = each.value.snippets_access_level
  repository_access_level              = each.value.repository_access_level
  pages_access_level                   = each.value.pages_access_level
  analytics_access_level               = each.value.analytics_access_level
  requirements_access_level            = each.value.requirements_access_level
  environments_access_level            = each.value.environments_access_level
  feature_flags_access_level           = each.value.feature_flags_access_level
  infrastructure_access_level          = each.value.infrastructure_access_level
  monitor_access_level                 = each.value.monitor_access_level
  releases_access_level                = each.value.releases_access_level
  security_and_compliance_access_level = each.value.security_and_compliance_access_level
  container_registry_access_level      = each.value.container_registry_access_level
  model_experiments_access_level       = each.value.model_experiments_access_level
  model_registry_access_level          = each.value.model_registry_access_level

  # CI/CD Settings
  ci_config_path                              = each.value.ci_config_path
  ci_default_git_depth                        = each.value.ci_default_git_depth
  ci_pipeline_variables_minimum_override_role = each.value.ci_pipeline_variables_minimum_override_role
  auto_devops_enabled                         = each.value.auto_devops_enabled
  auto_devops_deploy_strategy                 = each.value.auto_devops_deploy_strategy
  build_timeout                               = each.value.build_timeout
  build_git_strategy                          = each.value.build_git_strategy
  auto_cancel_pending_pipelines               = each.value.auto_cancel_pending_pipelines
  ci_forward_deployment_enabled               = each.value.ci_forward_deployment_enabled
  ci_separated_caches                         = each.value.ci_separated_caches
  public_jobs                                 = each.value.public_jobs
  shared_runners_enabled                      = each.value.shared_runners_enabled
  group_runners_enabled                       = each.value.group_runners_enabled
  keep_latest_artifact                        = each.value.keep_latest_artifact

  # Merge Request Settings
  only_allow_merge_if_pipeline_succeeds            = each.value.only_allow_merge_if_pipeline_succeeds
  only_allow_merge_if_all_discussions_are_resolved = each.value.only_allow_merge_if_all_discussions_are_resolved
  merge_method                                     = each.value.merge_method
  merge_pipelines_enabled                          = each.value.merge_pipelines_enabled
  merge_trains_enabled                             = each.value.merge_trains_enabled
  remove_source_branch_after_merge                 = each.value.remove_source_branch_after_merge
  merge_commit_template                            = each.value.merge_commit_template
  squash_option                                    = each.value.squash_option
  squash_commit_template                           = each.value.squash_commit_template
  resolve_outdated_diff_discussions                = each.value.resolve_outdated_diff_discussions
  printing_merge_request_link_enabled              = each.value.printing_merge_request_link_enabled
  merge_requests_template                          = each.value.merge_requests_template

  # Protection & Security
  archived                             = each.value.archived
  archive_on_destroy                   = each.value.archive_on_destroy
  lfs_enabled                          = each.value.lfs_enabled
  pre_receive_secret_detection_enabled = each.value.pre_receive_secret_detection_enabled

  # Push Rules
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

  # Additional Features
  avatar                                  = each.value.avatar
  avatar_hash                             = each.value.avatar_hash
  topics                                  = each.value.topics
  request_access_enabled                  = each.value.request_access_enabled
  emails_enabled                          = each.value.emails_enabled
  autoclose_referenced_issues             = each.value.autoclose_referenced_issues
  issues_template                         = each.value.issues_template
  suggestion_commit_message               = each.value.suggestion_commit_message
  packages_enabled                        = each.value.packages_enabled
  skip_wait_for_default_branch_protection = each.value.skip_wait_for_default_branch_protection
  auto_duo_code_review_enabled            = each.value.auto_duo_code_review_enabled

  # Container Expiration Policy
  dynamic "container_expiration_policy" {
    for_each = each.value.container_expiration_policy != null ? [each.value.container_expiration_policy] : []
    content {
      cadence           = container_expiration_policy.value.cadence
      enabled           = container_expiration_policy.value.enabled
      keep_n            = container_expiration_policy.value.keep_n
      older_than        = container_expiration_policy.value.older_than
      name_regex_delete = container_expiration_policy.value.name_regex_delete
      name_regex_keep   = container_expiration_policy.value.name_regex_keep
    }
  }

  lifecycle {
    ignore_changes = all
  }
}
