resource "gitlab_group_deploy_token" "group_tokens" {
  for_each = var.target.type == "group" && !var.create_only ? local.all_tokens : {}
  group    = var.target.id
  name     = each.key
  scopes   = each.value.scopes

  username                      = each.value.username
  expires_at                    = each.value.expires_at
  validate_past_expiration_date = each.value.validate_past_expiration_date

  lifecycle {
    precondition {
      condition     = local.scopes_are_valid
      error_message = "Invalid scopes found: ${join(", ", local.invalid_scopes)}. Valid scopes: ${join(", ", local.valid_scopes)}"
    }
  }
}

resource "gitlab_project_deploy_token" "project_tokens" {
  for_each = var.target.type == "project" && !var.create_only ? local.all_tokens : {}
  project  = var.target.id
  name     = each.key
  scopes   = each.value.scopes

  username                      = each.value.username
  expires_at                    = each.value.expires_at
  validate_past_expiration_date = each.value.validate_past_expiration_date

  lifecycle {
    precondition {
      condition     = local.scopes_are_valid
      error_message = "Invalid scopes found: ${join(", ", local.invalid_scopes)}. Valid scopes: ${join(", ", local.valid_scopes)}"
    }
  }
}

resource "gitlab_group_deploy_token" "create_only_group_tokens" {
  for_each = var.target.type == "group" && var.create_only ? local.all_tokens : {}
  group    = var.target.id
  name     = each.key
  scopes   = each.value.scopes

  username                      = each.value.username
  expires_at                    = each.value.expires_at
  validate_past_expiration_date = each.value.validate_past_expiration_date

  lifecycle {
    ignore_changes = [
      scopes,
      username,
      expires_at,
      validate_past_expiration_date,
    ]
    precondition {
      condition     = local.scopes_are_valid
      error_message = "Invalid scopes found: ${join(", ", local.invalid_scopes)}. Valid scopes: ${join(", ", local.valid_scopes)}"
    }
  }
}

resource "gitlab_project_deploy_token" "create_only_project_tokens" {
  for_each = var.target.type == "project" && var.create_only ? local.all_tokens : {}
  project  = var.target.id
  name     = each.key
  scopes   = each.value.scopes

  username                      = each.value.username
  expires_at                    = each.value.expires_at
  validate_past_expiration_date = each.value.validate_past_expiration_date

  lifecycle {
    ignore_changes = [
      scopes,
      username,
      expires_at,
      validate_past_expiration_date,
    ]
    precondition {
      condition     = local.scopes_are_valid
      error_message = "Invalid scopes found: ${join(", ", local.invalid_scopes)}. Valid scopes: ${join(", ", local.valid_scopes)}"
    }
  }
}
