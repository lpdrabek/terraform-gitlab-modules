resource "gitlab_group_membership" "members" {
  for_each = var.target.type == "group" ? local.all_memberships : {}

  group_id                      = var.target.id
  user_id                       = each.value.user_id
  access_level                  = each.value.access_level
  expires_at                    = each.value.expires_at
  member_role_id                = each.value.member_role_id
  skip_subresources_on_destroy  = each.value.skip_subresources_on_destroy
  unassign_issuables_on_destroy = each.value.unassign_issuables_on_destroy
}

resource "gitlab_project_membership" "members" {
  for_each = var.target.type == "project" ? local.all_memberships : {}

  project        = var.target.id
  user_id        = each.value.user_id
  access_level   = each.value.access_level
  expires_at     = each.value.expires_at
  member_role_id = each.value.member_role_id
}
