data "gitlab_project_mirror_public_key" "mirror_key" {
  for_each   = local.ssh_push_targets
  project_id = each.key
  mirror_id  = gitlab_project_push_mirror.push_target[each.key].mirror_id
}
