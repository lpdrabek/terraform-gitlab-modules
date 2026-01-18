locals {
  yaml_content = try(yamldecode(file(var.target_file)), {})

  target_from_file = {
    for project, config in local.yaml_content :
    project => {
      url                                 = config.url
      enabled                             = try(config.enabled, true)
      mirror_branch_regex                 = try(config.mirror_branch_regex, null)
      auth_method                         = try(config.auth_method, null)
      keep_divergent_refs                 = try(config.keep_divergent_refs, null)
      only_protected_branches             = try(config.only_protected_branches, null)
      auth_password                       = try(config.auth_password, null)
      auth_user                           = try(config.auth_user, null)
      mirror_overwrites_diverged_branches = try(config.mirror_overwrites_diverged_branches, null)
      mirror_trigger_builds               = try(config.mirror_trigger_builds, null)
      only_mirror_protected_branches      = try(config.only_mirror_protected_branches, null)
    }
  }

  all_targets = merge(local.target_from_file, var.target)

  ssh_push_targets = {
    for k, v in var.target : k => v
    if var.type == "push" && v.auth_method == "ssh_public_key"
  }
}
