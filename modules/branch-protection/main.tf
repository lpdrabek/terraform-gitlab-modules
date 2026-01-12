resource "gitlab_branch_protection" "branches" {
  for_each = var.create_only ? {} : local.all_branches

  project                      = var.project
  branch                       = each.key
  push_access_level            = each.value.push_access_level
  merge_access_level           = each.value.merge_access_level
  unprotect_access_level       = each.value.unprotect_access_level
  allow_force_push             = each.value.allow_force_push
  code_owner_approval_required = each.value.code_owner_approval_required

  # Users
  dynamic "allowed_to_push" {
    for_each = toset(local.push_user_ids[each.key])
    content {
      user_id = allowed_to_push.value
    }
  }
  dynamic "allowed_to_merge" {
    for_each = toset(local.merge_user_ids[each.key])
    content {
      user_id = allowed_to_merge.value
    }
  }
  dynamic "allowed_to_unprotect" {
    for_each = toset(local.unprotect_user_ids[each.key])
    content {
      user_id = allowed_to_unprotect.value
    }
  }

  # Groups
  dynamic "allowed_to_merge" {
    for_each = toset(local.merge_group_ids[each.key])
    content {
      group_id = allowed_to_merge.value
    }
  }
  dynamic "allowed_to_push" {
    for_each = toset(local.push_group_ids[each.key])
    content {
      group_id = allowed_to_push.value
    }
  }
  dynamic "allowed_to_unprotect" {
    for_each = toset(local.unprotect_group_ids[each.key])
    content {
      group_id = allowed_to_unprotect.value
    }
  }
}

resource "gitlab_branch_protection" "create_only_branches" {
  for_each = var.create_only ? local.all_branches : {}

  project                      = var.project
  branch                       = each.key
  push_access_level            = each.value.push_access_level
  merge_access_level           = each.value.merge_access_level
  unprotect_access_level       = each.value.unprotect_access_level
  allow_force_push             = each.value.allow_force_push
  code_owner_approval_required = each.value.code_owner_approval_required

  # Users
  dynamic "allowed_to_push" {
    for_each = toset(local.push_user_ids[each.key])
    content {
      user_id = allowed_to_push.value
    }
  }
  dynamic "allowed_to_merge" {
    for_each = toset(local.merge_user_ids[each.key])
    content {
      user_id = allowed_to_merge.value
    }
  }
  dynamic "allowed_to_unprotect" {
    for_each = toset(local.unprotect_user_ids[each.key])
    content {
      user_id = allowed_to_unprotect.value
    }
  }

  # Groups
  dynamic "allowed_to_merge" {
    for_each = toset(local.merge_group_ids[each.key])
    content {
      group_id = allowed_to_merge.value
    }
  }
  dynamic "allowed_to_push" {
    for_each = toset(local.push_group_ids[each.key])
    content {
      group_id = allowed_to_push.value
    }
  }
  dynamic "allowed_to_unprotect" {
    for_each = toset(local.unprotect_group_ids[each.key])
    content {
      group_id = allowed_to_unprotect.value
    }
  }

  lifecycle {
    ignore_changes = all
  }
}
