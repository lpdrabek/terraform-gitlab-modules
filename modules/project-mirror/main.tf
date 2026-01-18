resource "gitlab_project_push_mirror" "push_target" {
  for_each                = var.type == "push" ? local.all_targets : {}
  project                 = each.key
  url                     = each.value.url
  auth_method             = each.value.auth_method
  enabled                 = each.value.enabled
  keep_divergent_refs     = each.value.keep_divergent_refs
  mirror_branch_regex     = each.value.mirror_branch_regex
  only_protected_branches = each.value.only_protected_branches
}

resource "gitlab_project_pull_mirror" "pull_target" {
  for_each                            = var.type == "pull" ? local.all_targets : {}
  project                             = each.key
  url                                 = each.value.url
  auth_password                       = each.value.auth_password
  auth_user                           = each.value.auth_user
  enabled                             = each.value.enabled
  mirror_branch_regex                 = each.value.mirror_branch_regex
  mirror_overwrites_diverged_branches = each.value.mirror_overwrites_diverged_branches
  mirror_trigger_builds               = each.value.mirror_trigger_builds
  only_mirror_protected_branches      = each.value.only_mirror_protected_branches
}
