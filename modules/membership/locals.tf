locals {
  yaml_content = try(yamldecode(file(var.membership_file)), {})

  membership_from_file = {
    for access_level, config in local.yaml_content :
    access_level => {
      users                         = config.users
      find_users                    = try(config.find_users, "email")
      expires_at                    = try(config.expires_at, null)
      member_role_id                = try(config.member_role_id, null)
      skip_subresources_on_destroy  = try(config.skip_subresources_on_destroy, null)
      unassign_issuables_on_destroy = try(config.unassign_issuables_on_destroy, null)
    }
  }

  all_membership_config = merge(local.membership_from_file, var.membership)

  users_for_email_lookup = merge([
    for access_level, config in local.all_membership_config : {
      for user in config.users :
      "${access_level}:${user}" => {
        email        = user
        access_level = access_level
        config       = config
      } if config.find_users == "email"
    }
  ]...)
  users_for_username_lookup = merge([
    for access_level, config in local.all_membership_config : {
      for user in config.users :
      "${access_level}:${user}" => {
        username     = user
        access_level = access_level
        config       = config
      } if config.find_users == "username"
    }
  ]...)
  users_for_userid_lookup = merge([
    for access_level, config in local.all_membership_config : {
      for user in config.users :
      "${access_level}:${user}" => {
        user_id      = user
        access_level = access_level
        config       = config
      } if config.find_users == "userid"
    }
  ]...)

  all_memberships = merge(
    {
      for key, lookup in data.gitlab_user.email_lookup :
      key => {
        user_id                       = lookup.id
        access_level                  = local.users_for_email_lookup[key].access_level
        expires_at                    = local.users_for_email_lookup[key].config.expires_at
        member_role_id                = local.users_for_email_lookup[key].config.member_role_id
        skip_subresources_on_destroy  = local.users_for_email_lookup[key].config.skip_subresources_on_destroy
        unassign_issuables_on_destroy = local.users_for_email_lookup[key].config.unassign_issuables_on_destroy
      }
    },
    {
      for key, lookup in data.gitlab_user.username_lookup :
      key => {
        user_id                       = lookup.id
        access_level                  = local.users_for_username_lookup[key].access_level
        expires_at                    = local.users_for_username_lookup[key].config.expires_at
        member_role_id                = local.users_for_username_lookup[key].config.member_role_id
        skip_subresources_on_destroy  = local.users_for_username_lookup[key].config.skip_subresources_on_destroy
        unassign_issuables_on_destroy = local.users_for_username_lookup[key].config.unassign_issuables_on_destroy
      }
    },
    {
      for key, lookup in data.gitlab_user.userid_lookup :
      key => {
        user_id                       = lookup.id
        access_level                  = local.users_for_userid_lookup[key].access_level
        expires_at                    = local.users_for_userid_lookup[key].config.expires_at
        member_role_id                = local.users_for_userid_lookup[key].config.member_role_id
        skip_subresources_on_destroy  = local.users_for_userid_lookup[key].config.skip_subresources_on_destroy
        unassign_issuables_on_destroy = local.users_for_userid_lookup[key].config.unassign_issuables_on_destroy
      }
    }
  )
}
