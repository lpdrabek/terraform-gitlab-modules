locals {
  yaml_content = try(yamldecode(file(var.tags_file)), {})

  tags_from_file = {
    for tag_name, config in local.yaml_content :
    tag_name => {
      search_by                = try(config.search_by, "email")
      create_access_level      = try(config.create_access_level, null)
      allowed_to_create        = try(config.allowed_to_create, [])
      groups_allowed_to_create = try(config.groups_allowed_to_create, [])
    }
  }

  all_tags = merge(local.tags_from_file, var.tags)

  create_users_email = merge([
    for tag_name, tag in local.all_tags : {
      for user in coalesce(tag.allowed_to_create, []) :
      "${tag_name}:create:${user}" => {
        tag    = tag_name
        email  = user
        config = tag
      } if tag.search_by == "email"
    }
  ]...)
  create_users_username = merge([
    for tag_name, tag in local.all_tags : {
      for user in coalesce(tag.allowed_to_create, []) :
      "${tag_name}:create:${user}" => {
        tag      = tag_name
        username = user
        config   = tag
      } if tag.search_by == "username"
    }
  ]...)
  create_users_userid = merge([
    for tag_name, tag in local.all_tags : {
      for user in coalesce(tag.allowed_to_create, []) :
      "${tag_name}:create:${user}" => {
        tag     = tag_name
        user_id = user
        config  = tag
      } if tag.search_by == "userid"
    }
  ]...)

  create_groups_groupid = merge([
    for tag_name, tag in local.all_tags : {
      for group in coalesce(tag.groups_allowed_to_create, []) :
      "${tag_name}:create:${group}" => {
        tag      = tag_name
        group_id = group
        config   = tag
      } if tag.search_by == "groupid"
    }
  ]...)
  create_groups_fullpath = merge([
    for tag_name, tag in local.all_tags : {
      for group in coalesce(tag.groups_allowed_to_create, []) :
      "${tag_name}:create:${group}" => {
        tag       = tag_name
        full_path = group
        config    = tag
      } if tag.search_by == "fullpath"
    }
  ]...)

  # toset() will get rid of the duplicates
  unique_user_emails = toset([
    for key, val in local.create_users_email : val.email
  ])
  unique_user_usernames = toset([
    for key, val in local.create_users_username : val.username
  ])
  unique_user_ids = toset([
    for key, val in local.create_users_userid : val.user_id
  ])
  unique_group_ids = toset([
    for key, val in local.create_groups_groupid : val.group_id
  ])
  unique_group_fullpaths = toset([
    for key, val in local.create_groups_fullpath : val.full_path
  ])

  user_id_by_email = {
    for email in local.unique_user_emails :
    email => data.gitlab_user.by_email[email].id
  }
  user_id_by_username = {
    for username in local.unique_user_usernames :
    username => data.gitlab_user.by_username[username].id
  }
  user_id_by_userid = {
    for user_id in local.unique_user_ids :
    user_id => data.gitlab_user.by_userid[user_id].id
  }

  group_id_by_groupid = {
    for group_id in local.unique_group_ids :
    group_id => data.gitlab_group.by_groupid[group_id].id
  }
  group_id_by_fullpath = {
    for full_path in local.unique_group_fullpaths :
    full_path => data.gitlab_group.by_fullpath[full_path].id
  }

  create_user_ids = {
    for tag_name, tag in local.all_tags :
    tag_name => concat(
      [
        for user in coalesce(tag.allowed_to_create, []) :
        local.user_id_by_email[user] if tag.search_by == "email"
      ],
      [
        for user in coalesce(tag.allowed_to_create, []) :
        local.user_id_by_username[user] if tag.search_by == "username"
      ],
      [
        for user in coalesce(tag.allowed_to_create, []) :
        local.user_id_by_userid[user] if tag.search_by == "userid"
      ]
    )
  }

  create_group_ids = {
    for tag_name, tag in local.all_tags :
    tag_name => concat(
      [
        for group in coalesce(tag.groups_allowed_to_create, []) :
        local.group_id_by_groupid[group] if tag.search_by == "groupid"
      ],
      [
        for group in coalesce(tag.groups_allowed_to_create, []) :
        local.group_id_by_fullpath[group] if tag.search_by == "fullpath"
      ]
    )
  }
}
