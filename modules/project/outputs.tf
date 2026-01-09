output "projects" {
  description = "Map of created GitLab projects with their attributes"
  value = var.create_only ? {
    for key, project in gitlab_project.create_only_projects :
    key => project
    } : {
    for key, project in gitlab_project.projects :
    key => project
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
