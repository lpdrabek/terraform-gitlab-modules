resource "gitlab_user_runner" "runner" {
  for_each = var.create_only ? {} : local.all_runners

  runner_type      = each.value.runner_type
  access_level     = each.value.access_level
  description      = each.value.description
  group_id         = each.value.group_id
  locked           = each.value.locked
  maintenance_note = each.value.maintenance_note
  maximum_timeout  = each.value.maximum_timeout
  paused           = each.value.paused
  project_id       = each.value.project_id
  tag_list         = each.value.tag_list
  untagged         = each.value.untagged
}

resource "gitlab_user_runner" "create_only_runner" {
  for_each = !var.create_only ? {} : local.all_runners

  runner_type      = each.value.runner_type
  access_level     = each.value.access_level
  description      = each.value.description
  group_id         = each.value.group_id
  locked           = each.value.locked
  maintenance_note = each.value.maintenance_note
  maximum_timeout  = each.value.maximum_timeout
  paused           = each.value.paused
  project_id       = each.value.project_id
  tag_list         = each.value.tag_list
  untagged         = each.value.untagged

  lifecycle {
    ignore_changes = all
  }
}
