resource "gitlab_group_access_token" "tokens" {
  for_each                      = var.target.type == "group" ? local.all_tokens : {}
  group                         = var.target.id
  name                          = each.key
  access_level                  = each.value.access_level
  description                   = each.value.description
  expires_at                    = each.value.expires_at
  validate_past_expiration_date = each.value.validate_past_expiration_date
  scopes                        = each.value.scopes

  lifecycle {
    precondition {
      condition     = local.scopes_are_valid
      error_message = "Invalid scopes found: ${join(", ", local.invalid_scopes)}. Valid scopes for group tokens: ${join(", ", local.group_scopes)}"
    }
    precondition {
      condition     = length(local.tokens_missing_expiry) == 0
      error_message = "The following tokens are missing required 'expires_at' field: ${join(", ", local.tokens_missing_expiry)}"
    }
  }

  # https://gitlab.com/gitlab-org/terraform-provider-gitlab/-/issues/6164
  # Looks like it's only implemented for PAT, but let me leave it here for the future
  #
  #   dynamic "rotation_configuration" {
  #     for_each = each.value.rotation_configuration != null ? [each.value.rotation_configuration] : []
  #     content {
  #       expiration_days    = rotation_configuration.value.expiration_days
  #       rotate_before_days = rotation_configuration.value.rotate_before_days
  #     }
  #   }
}

resource "gitlab_project_access_token" "tokens" {
  for_each                      = var.target.type == "project" ? local.all_tokens : {}
  project                       = var.target.id
  name                          = each.key
  access_level                  = each.value.access_level
  description                   = each.value.description
  expires_at                    = each.value.expires_at
  validate_past_expiration_date = each.value.validate_past_expiration_date
  scopes                        = each.value.scopes

  lifecycle {
    precondition {
      condition     = local.scopes_are_valid
      error_message = "Invalid scopes found: ${join(", ", local.invalid_scopes)}. Valid scopes for project tokens: ${join(", ", local.project_scopes)}"
    }
    precondition {
      condition     = length(local.tokens_missing_expiry) == 0
      error_message = "The following tokens are missing required 'expires_at' field: ${join(", ", local.tokens_missing_expiry)}"
    }
  }

  # https://gitlab.com/gitlab-org/terraform-provider-gitlab/-/issues/6164
  # Looks like it's only implemented for PAT, but let me leave it here for the future
  #
  #   dynamic "rotation_configuration" {
  #     for_each = each.value.rotation_configuration != null ? [each.value.rotation_configuration] : []
  #     content {
  #       expiration_days    = rotation_configuration.value.expiration_days
  #       rotate_before_days = rotation_configuration.value.rotate_before_days
  #     }
  #   }
}

resource "gitlab_personal_access_token" "tokens" {
  for_each                      = var.target.type == "personal" ? local.all_tokens : {}
  user_id                       = var.target.id
  name                          = each.key
  description                   = each.value.description
  expires_at                    = each.value.expires_at
  validate_past_expiration_date = each.value.validate_past_expiration_date
  scopes                        = each.value.scopes

  lifecycle {
    precondition {
      condition     = local.scopes_are_valid
      error_message = "Invalid scopes found: ${join(", ", local.invalid_scopes)}. Valid scopes for personal tokens: ${join(", ", local.personal_scopes)}"
    }
    precondition {
      condition     = each.value.access_level == null || each.value.access_level == "maintainer"
      error_message = "access_level is not supported for personal access tokens (token: ${each.key})"
    }
    precondition {
      condition     = length(local.tokens_missing_expiry) == 0
      error_message = "The following tokens are missing required 'expires_at' field: ${join(", ", local.tokens_missing_expiry)}"
    }
  }


  ## Or not? I don't get it... It's in the documenation for all of those resources
  #   dynamic "rotation_configuration" {
  #     for_each = each.value.rotation_configuration != null ? [each.value.rotation_configuration] : []
  #     content {
  #       expiration_days    = rotation_configuration.value.expiration_days
  #       rotate_before_days = rotation_configuration.value.rotate_before_days
  #     }
  #   }
}
