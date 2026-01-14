resource "gitlab_tag_protection" "tags" {
  for_each = var.create_only ? {} : local.all_tags

  project             = var.project
  tag                 = each.key
  create_access_level = each.value.create_access_level

  # Dynamic blocks for allowed_to_create users
  dynamic "allowed_to_create" {
    for_each = toset(local.create_user_ids[each.key])
    content {
      user_id = allowed_to_create.value
    }
  }

  # Dynamic blocks for allowed_to_create groups
  dynamic "allowed_to_create" {
    for_each = toset(local.create_group_ids[each.key])
    content {
      group_id = allowed_to_create.value
    }
  }
}

resource "gitlab_tag_protection" "create_only_tags" {
  for_each = var.create_only ? local.all_tags : {}

  project             = var.project
  tag                 = each.key
  create_access_level = each.value.create_access_level

  # Dynamic blocks for allowed_to_create users
  dynamic "allowed_to_create" {
    for_each = toset(local.create_user_ids[each.key])
    content {
      user_id = allowed_to_create.value
    }
  }

  # Dynamic blocks for allowed_to_create groups
  dynamic "allowed_to_create" {
    for_each = toset(local.create_group_ids[each.key])
    content {
      group_id = allowed_to_create.value
    }
  }

  lifecycle {
    ignore_changes = all
  }
}
