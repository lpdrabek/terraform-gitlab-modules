data "gitlab_user" "by_email" {
  for_each = local.unique_user_emails
  email    = each.value
}

data "gitlab_user" "by_username" {
  for_each = local.unique_user_usernames
  username = each.value
}

data "gitlab_user" "by_userid" {
  for_each = local.unique_user_ids
  user_id  = tonumber(each.value)
}

data "gitlab_group" "by_groupid" {
  for_each = local.unique_group_ids
  group_id = tonumber(each.value)
}

data "gitlab_group" "by_fullpath" {
  for_each  = local.unique_group_fullpaths
  full_path = each.value
}
