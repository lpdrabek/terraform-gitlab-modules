data "gitlab_user" "email_lookup" {
  for_each = local.users_for_email_lookup
  email    = each.value.email
}

data "gitlab_user" "username_lookup" {
  for_each = local.users_for_username_lookup
  username = each.value.username
}

data "gitlab_user" "userid_lookup" {
  for_each = local.users_for_userid_lookup
  user_id  = tonumber(each.value.user_id)
}
