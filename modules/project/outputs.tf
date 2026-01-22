output "projects" {
  description = "Map of created GitLab projects with their attributes"
  value = var.create_only ? {
    for key, project in gitlab_project.create_only_projects :
    key => {
      id                                   = project.id
      name                                 = project.name
      path                                 = project.path
      path_with_namespace                  = project.path_with_namespace
      namespace_id                         = project.namespace_id
      description                          = project.description
      default_branch                       = project.default_branch
      visibility_level                     = project.visibility_level
      web_url                              = project.web_url
      ssh_url_to_repo                      = project.ssh_url_to_repo
      http_url_to_repo                     = project.http_url_to_repo
      archived                             = project.archived
      avatar_url                           = project.avatar_url
      empty_repo                           = project.empty_repo
      topics                               = project.topics
      issues_access_level                  = project.issues_access_level
      merge_requests_access_level          = project.merge_requests_access_level
      builds_access_level                  = project.builds_access_level
      wiki_access_level                    = project.wiki_access_level
      snippets_access_level                = project.snippets_access_level
      pages_access_level                   = project.pages_access_level
      repository_access_level              = project.repository_access_level
      container_registry_access_level      = project.container_registry_access_level
      analytics_access_level               = project.analytics_access_level
      environments_access_level            = project.environments_access_level
      feature_flags_access_level           = project.feature_flags_access_level
      infrastructure_access_level          = project.infrastructure_access_level
      monitor_access_level                 = project.monitor_access_level
      releases_access_level                = project.releases_access_level
      security_and_compliance_access_level = project.security_and_compliance_access_level
      requirements_access_level            = project.requirements_access_level
      model_experiments_access_level       = project.model_experiments_access_level
      model_registry_access_level          = project.model_registry_access_level
      shared_runners_enabled               = project.shared_runners_enabled
      group_runners_enabled                = project.group_runners_enabled
      merge_method                         = project.merge_method
      squash_option                        = project.squash_option
      request_access_enabled               = project.request_access_enabled
      lfs_enabled                          = project.lfs_enabled
      packages_enabled                     = project.packages_enabled
      forking_access_level                 = project.forking_access_level
    }
    } : {
    for key, project in gitlab_project.projects :
    key => {
      id                                   = project.id
      name                                 = project.name
      path                                 = project.path
      path_with_namespace                  = project.path_with_namespace
      namespace_id                         = project.namespace_id
      description                          = project.description
      default_branch                       = project.default_branch
      visibility_level                     = project.visibility_level
      web_url                              = project.web_url
      ssh_url_to_repo                      = project.ssh_url_to_repo
      http_url_to_repo                     = project.http_url_to_repo
      archived                             = project.archived
      avatar_url                           = project.avatar_url
      empty_repo                           = project.empty_repo
      topics                               = project.topics
      issues_access_level                  = project.issues_access_level
      merge_requests_access_level          = project.merge_requests_access_level
      builds_access_level                  = project.builds_access_level
      wiki_access_level                    = project.wiki_access_level
      snippets_access_level                = project.snippets_access_level
      pages_access_level                   = project.pages_access_level
      repository_access_level              = project.repository_access_level
      container_registry_access_level      = project.container_registry_access_level
      analytics_access_level               = project.analytics_access_level
      environments_access_level            = project.environments_access_level
      feature_flags_access_level           = project.feature_flags_access_level
      infrastructure_access_level          = project.infrastructure_access_level
      monitor_access_level                 = project.monitor_access_level
      releases_access_level                = project.releases_access_level
      security_and_compliance_access_level = project.security_and_compliance_access_level
      requirements_access_level            = project.requirements_access_level
      model_experiments_access_level       = project.model_experiments_access_level
      model_registry_access_level          = project.model_registry_access_level
      shared_runners_enabled               = project.shared_runners_enabled
      group_runners_enabled                = project.group_runners_enabled
      merge_method                         = project.merge_method
      squash_option                        = project.squash_option
      request_access_enabled               = project.request_access_enabled
      lfs_enabled                          = project.lfs_enabled
      packages_enabled                     = project.packages_enabled
      forking_access_level                 = project.forking_access_level
    }
  }
}

output "projects_sensitive" {
  description = "Sensitive attributes of created GitLab projects (runners_token)"
  sensitive   = true
  value = var.create_only ? {
    for key, project in gitlab_project.create_only_projects :
    key => {
      runners_token = project.runners_token
    }
    } : {
    for key, project in gitlab_project.projects :
    key => {
      runners_token = project.runners_token
    }
  }
}

output "project_ids" {
  description = "Map of project names to their IDs"
  value = var.create_only ? {
    for key, project in gitlab_project.create_only_projects :
    key => project.id
    } : {
    for key, project in gitlab_project.projects :
    key => project.id
  }
}

output "project_paths_with_namespace" {
  description = "Map of project names to their paths with namespace"
  value = var.create_only ? {
    for key, project in gitlab_project.create_only_projects :
    key => project.path_with_namespace
    } : {
    for key, project in gitlab_project.projects :
    key => project.path_with_namespace
  }
}

output "project_web_urls" {
  description = "Map of project names to their web URLs"
  value = var.create_only ? {
    for key, project in gitlab_project.create_only_projects :
    key => project.web_url
    } : {
    for key, project in gitlab_project.projects :
    key => project.web_url
  }
}

output "project_ssh_urls_to_repo" {
  description = "Map of project names to their SSH URLs"
  value = var.create_only ? {
    for key, project in gitlab_project.create_only_projects :
    key => project.ssh_url_to_repo
    } : {
    for key, project in gitlab_project.projects :
    key => project.ssh_url_to_repo
  }
}

output "project_http_urls_to_repo" {
  description = "Map of project names to their HTTP URLs"
  value = var.create_only ? {
    for key, project in gitlab_project.create_only_projects :
    key => project.http_url_to_repo
    } : {
    for key, project in gitlab_project.projects :
    key => project.http_url_to_repo
  }
}

output "milestones" {
  description = "Map of project names to their created milestones"
  value = {
    for key, milestone_module in module.milestones :
    key => milestone_module.milestones
  }
}

output "labels" {
  description = "Map of project names to their created labels"
  value = {
    for key, labels_module in module.labels :
    key => labels_module.labels
  }
}

output "badges" {
  description = "Map of project names to their created badges"
  value = {
    for key, badges_module in module.badges :
    key => badges_module.badges
  }
}

output "issues" {
  description = "Map of project names to their created issues"
  value = {
    for key, issues_module in module.issues :
    key => issues_module.issues
  }
}

output "push_mirror_ssh_public_keys" {
  description = "SSH public keys for push mirrors using ssh_public_key authentication"
  value = {
    for key, mirror_module in module.push_mirror :
    key => mirror_module.mirror_keys
  }
  sensitive = true
}

output "pipeline_triggers" {
  description = "Map of project names to their pipeline trigger tokens"
  value = {
    for key, trigger in gitlab_pipeline_trigger.pipeline_trigger :
    key => {
      id          = trigger.id
      description = trigger.description
      token       = trigger.token
    }
  }
  sensitive = true
}
