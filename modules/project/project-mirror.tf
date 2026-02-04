module "push_mirror" {
  source  = "gitlab.com/gitlab-utl/project-mirror/gitlab"
  version = ">= 1.0.0, < 2.0.0"
  for_each = local.projects_with_push_mirror

  type = "push"

  target = {
    (var.create_only ? gitlab_project.create_only_projects[each.key].id : gitlab_project.projects[each.key].id) = {
      url                     = each.value.push_mirror.url
      auth_method             = each.value.push_mirror.auth_method
      enabled                 = each.value.push_mirror.enabled
      keep_divergent_refs     = each.value.push_mirror.keep_divergent_refs
      only_protected_branches = each.value.push_mirror.only_protected_branches
      mirror_branch_regex     = each.value.push_mirror.mirror_branch_regex
    }
  }
}

module "pull_mirror" {
  source  = "gitlab.com/gitlab-utl/project-mirror/gitlab"
  version = ">= 1.0.0, < 2.0.0"
  for_each = local.projects_with_pull_mirror

  type = "pull"

  target = {
    (var.create_only ? gitlab_project.create_only_projects[each.key].id : gitlab_project.projects[each.key].id) = {
      url                                 = each.value.pull_mirror.url
      auth_user                           = each.value.pull_mirror.auth_user
      auth_password                       = each.value.pull_mirror.auth_password
      enabled                             = each.value.pull_mirror.enabled
      mirror_overwrites_diverged_branches = each.value.pull_mirror.mirror_overwrites_diverged_branches
      mirror_trigger_builds               = each.value.pull_mirror.mirror_trigger_builds
      only_mirror_protected_branches      = each.value.pull_mirror.only_mirror_protected_branches
      mirror_branch_regex                 = each.value.pull_mirror.mirror_branch_regex
    }
  }
}
