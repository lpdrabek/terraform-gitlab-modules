module "projects" {
  source   = "gitlab.com/gitlab-utl/project/gitlab"
  version  = ">= 1.0.0, < 2.0.0"
  for_each = { for k, v in local.all_groups : k => v if length(v.projects) > 0 && !var.create_only }

  projects = {
    for project_name, project in each.value.projects :
    project_name => {
      namespace_id                                     = gitlab_group.groups[each.key].id
      description                                      = try(project.description, null)
      path                                             = try(project.path, null)
      visibility_level                                 = try(project.visibility_level, "private")
      default_branch                                   = try(project.default_branch, null)
      initialize_with_readme                           = try(project.initialize_with_readme, false)
      topics                                           = try(project.topics, [])
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
      push_rules                                       = try(project.push_rules, null)
      labels                                           = try(project.labels, {})
      labels_file                                      = try(project.labels_file, null)
      labels_create_only                               = try(project.labels_create_only, false)
      milestones                                       = try(project.milestones, {})
      milestones_file                                  = try(project.milestones_file, null)
      milestones_create_only                           = try(project.milestones_create_only, false)
      badges                                           = try(project.badges, {})
      badges_file                                      = try(project.badges_file, null)
      badges_create_only                               = try(project.badges_create_only, false)
      issues                                           = try(project.issues, {})
      issues_file                                      = try(project.issues_file, null)
      issues_create_only                               = try(project.issues_create_only, false)
      deploy_tokens                                    = try(project.deploy_tokens, {})
      deploy_tokens_file                               = try(project.deploy_tokens_file, null)
      deploy_tokens_create_only                        = try(project.deploy_tokens_create_only, false)
    }
  }
}

module "create_only_projects" {
  source   = "gitlab.com/gitlab-utl/project/gitlab"
  version  = ">= 1.0.0, < 2.0.0"
  for_each = { for k, v in local.all_groups : k => v if length(v.projects) > 0 && var.create_only }

  create_only = true

  projects = {
    for project_name, project in each.value.projects :
    project_name => {
      namespace_id                                     = gitlab_group.create_only_groups[each.key].id
      description                                      = try(project.description, null)
      path                                             = try(project.path, null)
      visibility_level                                 = try(project.visibility_level, "private")
      default_branch                                   = try(project.default_branch, null)
      initialize_with_readme                           = try(project.initialize_with_readme, false)
      topics                                           = try(project.topics, [])
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
      push_rules                                       = try(project.push_rules, null)
      labels                                           = try(project.labels, {})
      labels_file                                      = try(project.labels_file, null)
      labels_create_only                               = try(project.labels_create_only, false)
      milestones                                       = try(project.milestones, {})
      milestones_file                                  = try(project.milestones_file, null)
      milestones_create_only                           = try(project.milestones_create_only, false)
      badges                                           = try(project.badges, {})
      badges_file                                      = try(project.badges_file, null)
      badges_create_only                               = try(project.badges_create_only, false)
      issues                                           = try(project.issues, {})
      issues_file                                      = try(project.issues_file, null)
      issues_create_only                               = try(project.issues_create_only, false)
      deploy_tokens                                    = try(project.deploy_tokens, {})
      deploy_tokens_file                               = try(project.deploy_tokens_file, null)
      deploy_tokens_create_only                        = try(project.deploy_tokens_create_only, false)
    }
  }
}
