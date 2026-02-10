resource "gitlab_deploy_key" "deploy_keys" {
  for_each = !var.create_only ? local.create_keys : {}

  project    = var.project
  title      = each.key
  key        = each.value.key
  can_push   = each.value.can_push
  expires_at = each.value.expires_at
}

resource "gitlab_deploy_key" "create_only_deploy_keys" {
  for_each = var.create_only ? local.create_keys : {}

  project    = var.project
  title      = each.key
  key        = each.value.key
  can_push   = each.value.can_push
  expires_at = each.value.expires_at

  lifecycle {
    ignore_changes = [
      key,
      can_push,
      expires_at,
    ]
  }
}

resource "gitlab_deploy_key_enable" "enable_keys" {
  for_each = !var.create_only ? local.enable_keys : {}

  project = each.value.project
  key_id = (
    each.value.created
    ? tostring(gitlab_deploy_key.deploy_keys[each.value.name].deploy_key_id)
    : each.value.key_id
  )
  can_push = each.value.can_push
}

resource "gitlab_deploy_key_enable" "create_only_enable_keys" {
  for_each = var.create_only ? local.enable_keys : {}

  project = each.value.project
  key_id = (
    each.value.created
    ? tostring(gitlab_deploy_key.create_only_deploy_keys[each.value.name].deploy_key_id)
    : each.value.key_id
  )
  can_push = each.value.can_push

  lifecycle {
    ignore_changes = [
      can_push,
    ]
  }
}
