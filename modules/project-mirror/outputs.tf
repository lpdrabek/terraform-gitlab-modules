output "push_mirrors" {
  description = "Map of created push mirrors with their details"
  value = {
    for k, v in gitlab_project_push_mirror.push_target : k => {
      id                      = v.id
      mirror_id               = v.mirror_id
      url                     = v.url
      enabled                 = v.enabled
      only_protected_branches = v.only_protected_branches
    }
  }
  sensitive = true
}

output "pull_mirrors" {
  description = "Map of created pull mirrors with their details"
  value = {
    for k, v in gitlab_project_pull_mirror.pull_target : k => {
      id                             = v.id
      mirror_id                      = v.mirror_id
      url                            = v.url
      enabled                        = v.enabled
      only_mirror_protected_branches = v.only_mirror_protected_branches
    }
  }
  sensitive = true
}

output "mirrored_projects" {
  description = "List of project IDs/paths that have mirrors configured"
  value       = keys(local.all_targets)
}

output "mirror_keys" {
  description = "SSH public keys for push mirrors using ssh_public_key authentication"
  value = { for k, v in local.ssh_push_targets : k => {
    url        = v.url
    public_key = data.gitlab_project_mirror_public_key.mirror_key[k].public_key
    id         = data.gitlab_project_mirror_public_key.mirror_key[k].id
  } }
  sensitive = true # It's just public key, so technically safe to show, but I figured, let's add this as sensitive
  # You can still copy if from mirror repo page
}
