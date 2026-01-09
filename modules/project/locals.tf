locals {
  # Read YAML file if provided, otherwise empty map
  yaml_content = try(yamldecode(file(var.projects_file)), {})

  # Transform YAML content to match expected structure
  projects_from_file = {
    for name, project in local.yaml_content :
    name => {
      # Core Settings
      description      = try(project.description, null)
      namespace_id     = try(project.namespace_id, null)
      path             = try(project.path, null)
      visibility_level = try(project.visibility_level, "private")
      default_branch   = try(project.default_branch, null)

      # Repository Configuration
      import_url             = try(project.import_url, null)
      import_url_username    = try(project.import_url_username, null)
      import_url_password    = try(project.import_url_password, null)
      mirror                 = try(project.mirror, null)
      forked_from_project_id = try(project.forked_from_project_id, null)
      initialize_with_readme = try(project.initialize_with_readme, false)
      mr_default_target_self = try(project.mr_default_target_self, null)

      # Templates
      use_custom_template             = try(project.use_custom_template, false)
      template_name                   = try(project.template_name, null)
      template_project_id             = try(project.template_project_id, null)
      group_with_project_templates_id = try(project.group_with_project_templates_id, null)

      # Access Control - Features
      issues_access_level                  = try(project.issues_access_level, "enabled")
      merge_requests_access_level          = try(project.merge_requests_access_level, "enabled")
      wiki_access_level                    = try(project.wiki_access_level, "enabled")
      builds_access_level                  = try(project.builds_access_level, "enabled")
      snippets_access_level                = try(project.snippets_access_level, "enabled")
      repository_access_level              = try(project.repository_access_level, "enabled")
      pages_access_level                   = try(project.pages_access_level, "private")
      analytics_access_level               = try(project.analytics_access_level, "enabled")
      requirements_access_level            = try(project.requirements_access_level, "enabled")
      environments_access_level            = try(project.environments_access_level, "enabled")
      feature_flags_access_level           = try(project.feature_flags_access_level, "enabled")
      infrastructure_access_level          = try(project.infrastructure_access_level, "enabled")
      monitor_access_level                 = try(project.monitor_access_level, "enabled")
      releases_access_level                = try(project.releases_access_level, "enabled")
      security_and_compliance_access_level = try(project.security_and_compliance_access_level, "private")
      container_registry_access_level      = try(project.container_registry_access_level, "enabled")
      model_experiments_access_level       = try(project.model_experiments_access_level, "enabled")
      model_registry_access_level          = try(project.model_registry_access_level, "enabled")

      # CI/CD Settings
      ci_config_path                              = try(project.ci_config_path, null)
      ci_default_git_depth                        = try(project.ci_default_git_depth, null)
      ci_pipeline_variables_minimum_override_role = try(project.ci_pipeline_variables_minimum_override_role, null)
      auto_devops_enabled                         = try(project.auto_devops_enabled, null)
      auto_devops_deploy_strategy                 = try(project.auto_devops_deploy_strategy, null)
      build_timeout                               = try(project.build_timeout, 3600)
      build_git_strategy                          = try(project.build_git_strategy, "fetch")
      auto_cancel_pending_pipelines               = try(project.auto_cancel_pending_pipelines, "enabled")
      ci_forward_deployment_enabled               = try(project.ci_forward_deployment_enabled, null)
      ci_separated_caches                         = try(project.ci_separated_caches, true)
      public_jobs                                 = try(project.public_jobs, true)
      shared_runners_enabled                      = try(project.shared_runners_enabled, true)
      group_runners_enabled                       = try(project.group_runners_enabled, true)
      keep_latest_artifact                        = try(project.keep_latest_artifact, true)

      # Merge Request Settings
      only_allow_merge_if_pipeline_succeeds            = try(project.only_allow_merge_if_pipeline_succeeds, false)
      only_allow_merge_if_all_discussions_are_resolved = try(project.only_allow_merge_if_all_discussions_are_resolved, false)
      merge_method                                     = try(project.merge_method, "merge")
      merge_pipelines_enabled                          = try(project.merge_pipelines_enabled, false)
      merge_trains_enabled                             = try(project.merge_trains_enabled, false)
      remove_source_branch_after_merge                 = try(project.remove_source_branch_after_merge, false)
      merge_commit_template                            = try(project.merge_commit_template, null)
      squash_option                                    = try(project.squash_option, "default_off")
      squash_commit_template                           = try(project.squash_commit_template, null)
      resolve_outdated_diff_discussions                = try(project.resolve_outdated_diff_discussions, false)
      printing_merge_request_link_enabled              = try(project.printing_merge_request_link_enabled, true)
      merge_requests_template                          = try(project.merge_requests_template, null)

      # Protection & Security
      archived                             = try(project.archived, false)
      archive_on_destroy                   = try(project.archive_on_destroy, false)
      lfs_enabled                          = try(project.lfs_enabled, true)
      pre_receive_secret_detection_enabled = try(project.pre_receive_secret_detection_enabled, false)

      # Push Rules
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
        commit_committer_check        = try(project.push_rules.commit_committer_check, null)
        commit_committer_name_check   = try(project.push_rules.commit_committer_name_check, null)
      } : null

      # Additional Features
      avatar                                  = try(project.avatar, null)
      avatar_hash                             = try(project.avatar_hash, null)
      topics                                  = try(toset(project.topics), [])
      request_access_enabled                  = try(project.request_access_enabled, true)
      emails_enabled                          = try(project.emails_enabled, true)
      autoclose_referenced_issues             = try(project.autoclose_referenced_issues, true)
      issues_template                         = try(project.issues_template, null)
      suggestion_commit_message               = try(project.suggestion_commit_message, null)
      packages_enabled                        = try(project.packages_enabled, null)
      skip_wait_for_default_branch_protection = try(project.skip_wait_for_default_branch_protection, false)
      auto_duo_code_review_enabled            = try(project.auto_duo_code_review_enabled, false)

      # Container Expiration Policy
      container_expiration_policy = try(project.container_expiration_policy, null) != null ? {
        cadence           = try(project.container_expiration_policy.cadence, null)
        enabled           = try(project.container_expiration_policy.enabled, null)
        keep_n            = try(project.container_expiration_policy.keep_n, null)
        older_than        = try(project.container_expiration_policy.older_than, null)
        name_regex_delete = try(project.container_expiration_policy.name_regex_delete, null)
        name_regex_keep   = try(project.container_expiration_policy.name_regex_keep, null)
      } : null

      # Milestones
      milestones             = try(project.milestones, {})
      milestones_file        = try(project.milestones_file, null)
      milestones_create_only = try(project.milestones_create_only, false)

      # Labels
      labels             = try(project.labels, {})
      labels_file        = try(project.labels_file, null)
      labels_create_only = try(project.labels_create_only, false)

      # Badges
      badges             = try(project.badges, {})
      badges_file        = try(project.badges_file, null)
      badges_create_only = try(project.badges_create_only, false)

      # Issues
      issues             = try(project.issues, {})
      issues_file        = try(project.issues_file, null)
      issues_create_only = try(project.issues_create_only, false)
    }
  }

  all_projects = merge(var.projects, local.projects_from_file)
}
