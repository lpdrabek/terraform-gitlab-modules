locals {
  yaml_content = try(yamldecode(file(var.branches_file)), {})

  branches_from_file = {
    for branch_name, config in local.yaml_content :
    branch_name => {
      search_by                    = try(config.search_by, "email")
      push_access_level            = try(config.push_access_level, null)
      merge_access_level           = try(config.merge_access_level, null)
      unprotect_access_level       = try(config.unprotect_access_level, null)
      allow_force_push             = try(config.allow_force_push, false)
      code_owner_approval_required = try(config.code_owner_approval_required, false)
      allowed_to_push              = try(config.allowed_to_push, [])
      allowed_to_merge             = try(config.allowed_to_merge, [])
      allowed_to_unprotect         = try(config.allowed_to_unprotect, [])
      groups_allowed_to_push       = try(config.groups_allowed_to_push, [])
      groups_allowed_to_merge      = try(config.groups_allowed_to_merge, [])
      groups_allowed_to_unprotect  = try(config.groups_allowed_to_unprotect, [])
    }
  }

  all_branches = merge(local.branches_from_file, var.branches)

  push_users_email = merge([
    for branch_name, branch in local.all_branches : {
      for user in coalesce(branch.allowed_to_push, []) :
      "${branch_name}:push:${user}" => {
        branch = branch_name
        email  = user
        config = branch
      } if branch.search_by == "email"
    }
  ]...)
  push_users_username = merge([
    for branch_name, branch in local.all_branches : {
      for user in coalesce(branch.allowed_to_push, []) :
      "${branch_name}:push:${user}" => {
        branch   = branch_name
        username = user
        config   = branch
      } if branch.search_by == "username"
    }
  ]...)
  push_users_userid = merge([
    for branch_name, branch in local.all_branches : {
      for user in coalesce(branch.allowed_to_push, []) :
      "${branch_name}:push:${user}" => {
        branch  = branch_name
        user_id = user
        config  = branch
      } if branch.search_by == "userid"
    }
  ]...)


  merge_users_email = merge([
    for branch_name, branch in local.all_branches : {
      for user in coalesce(branch.allowed_to_merge, []) :
      "${branch_name}:merge:${user}" => {
        branch = branch_name
        email  = user
        config = branch
      } if branch.search_by == "email"
    }
  ]...)
  merge_users_username = merge([
    for branch_name, branch in local.all_branches : {
      for user in coalesce(branch.allowed_to_merge, []) :
      "${branch_name}:merge:${user}" => {
        branch   = branch_name
        username = user
        config   = branch
      } if branch.search_by == "username"
    }
  ]...)
  merge_users_userid = merge([
    for branch_name, branch in local.all_branches : {
      for user in coalesce(branch.allowed_to_merge, []) :
      "${branch_name}:merge:${user}" => {
        branch  = branch_name
        user_id = user
        config  = branch
      } if branch.search_by == "userid"
    }
  ]...)

  unprotect_users_email = merge([
    for branch_name, branch in local.all_branches : {
      for user in coalesce(branch.allowed_to_unprotect, []) :
      "${branch_name}:unprotect:${user}" => {
        branch = branch_name
        email  = user
        config = branch
      } if branch.search_by == "email"
    }
  ]...)
  unprotect_users_username = merge([
    for branch_name, branch in local.all_branches : {
      for user in coalesce(branch.allowed_to_unprotect, []) :
      "${branch_name}:unprotect:${user}" => {
        branch   = branch_name
        username = user
        config   = branch
      } if branch.search_by == "username"
    }
  ]...)
  unprotect_users_userid = merge([
    for branch_name, branch in local.all_branches : {
      for user in coalesce(branch.allowed_to_unprotect, []) :
      "${branch_name}:unprotect:${user}" => {
        branch  = branch_name
        user_id = user
        config  = branch
      } if branch.search_by == "userid"
    }
  ]...)

  push_groups_groupid = merge([
    for branch_name, branch in local.all_branches : {
      for group in coalesce(branch.groups_allowed_to_push, []) :
      "${branch_name}:push:${group}" => {
        branch   = branch_name
        group_id = group
        config   = branch
      } if branch.search_by == "groupid"
    }
  ]...)
  push_groups_fullpath = merge([
    for branch_name, branch in local.all_branches : {
      for group in coalesce(branch.groups_allowed_to_push, []) :
      "${branch_name}:push:${group}" => {
        branch    = branch_name
        full_path = group
        config    = branch
      } if branch.search_by == "fullpath"
    }
  ]...)
  merge_groups_groupid = merge([
    for branch_name, branch in local.all_branches : {
      for group in coalesce(branch.groups_allowed_to_merge, []) :
      "${branch_name}:merge:${group}" => {
        branch   = branch_name
        group_id = group
        config   = branch
      } if branch.search_by == "groupid"
    }
  ]...)
  merge_groups_fullpath = merge([
    for branch_name, branch in local.all_branches : {
      for group in coalesce(branch.groups_allowed_to_merge, []) :
      "${branch_name}:merge:${group}" => {
        branch    = branch_name
        full_path = group
        config    = branch
      } if branch.search_by == "fullpath"
    }
  ]...)
  unprotect_groups_groupid = merge([
    for branch_name, branch in local.all_branches : {
      for group in coalesce(branch.groups_allowed_to_unprotect, []) :
      "${branch_name}:unprotect:${group}" => {
        branch   = branch_name
        group_id = group
        config   = branch
      } if branch.search_by == "groupid"
    }
  ]...)
  unprotect_groups_fullpath = merge([
    for branch_name, branch in local.all_branches : {
      for group in coalesce(branch.groups_allowed_to_unprotect, []) :
      "${branch_name}:unprotect:${group}" => {
        branch    = branch_name
        full_path = group
        config    = branch
      } if branch.search_by == "fullpath"
    }
  ]...)

  # toset() will get rid of the duplicates
  unique_user_emails = toset([
    for key, val in merge(local.push_users_email, local.merge_users_email, local.unprotect_users_email) : val.email
  ])
  unique_user_usernames = toset([
    for key, val in merge(local.push_users_username, local.merge_users_username, local.unprotect_users_username) : val.username
  ])
  unique_user_ids = toset([
    for key, val in merge(local.push_users_userid, local.merge_users_userid, local.unprotect_users_userid) : val.user_id
  ])
  unique_group_ids = toset([
    for key, val in merge(local.push_groups_groupid, local.merge_groups_groupid, local.unprotect_groups_groupid) : val.group_id
  ])
  unique_group_fullpaths = toset([
    for key, val in merge(local.push_groups_fullpath, local.merge_groups_fullpath, local.unprotect_groups_fullpath) : val.full_path
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


  push_user_ids = {
    for branch_name, branch in local.all_branches :
    branch_name => concat(
      [
        for user in coalesce(branch.allowed_to_push, []) :
        local.user_id_by_email[user] if branch.search_by == "email"
      ],
      [
        for user in coalesce(branch.allowed_to_push, []) :
        local.user_id_by_username[user] if branch.search_by == "username"
      ],
      [
        for user in coalesce(branch.allowed_to_push, []) :
        local.user_id_by_userid[user] if branch.search_by == "userid"
      ]
    )
  }
  merge_user_ids = {
    for branch_name, branch in local.all_branches :
    branch_name => concat(
      [
        for user in coalesce(branch.allowed_to_merge, []) :
        local.user_id_by_email[user] if branch.search_by == "email"
      ],
      [
        for user in coalesce(branch.allowed_to_merge, []) :
        local.user_id_by_username[user] if branch.search_by == "username"
      ],
      [
        for user in coalesce(branch.allowed_to_merge, []) :
        local.user_id_by_userid[user] if branch.search_by == "userid"
      ]
    )
  }
  unprotect_user_ids = {
    for branch_name, branch in local.all_branches :
    branch_name => concat(
      [
        for user in coalesce(branch.allowed_to_unprotect, []) :
        local.user_id_by_email[user] if branch.search_by == "email"
      ],
      [
        for user in coalesce(branch.allowed_to_unprotect, []) :
        local.user_id_by_username[user] if branch.search_by == "username"
      ],
      [
        for user in coalesce(branch.allowed_to_unprotect, []) :
        local.user_id_by_userid[user] if branch.search_by == "userid"
      ]
    )
  }

  push_group_ids = {
    for branch_name, branch in local.all_branches :
    branch_name => concat(
      [
        for group in coalesce(branch.groups_allowed_to_push, []) :
        local.group_id_by_groupid[group] if branch.search_by == "groupid"
      ],
      [
        for group in coalesce(branch.groups_allowed_to_push, []) :
        local.group_id_by_fullpath[group] if branch.search_by == "fullpath"
      ]
    )
  }
  merge_group_ids = {
    for branch_name, branch in local.all_branches :
    branch_name => concat(
      [
        for group in coalesce(branch.groups_allowed_to_merge, []) :
        local.group_id_by_groupid[group] if branch.search_by == "groupid"
      ],
      [
        for group in coalesce(branch.groups_allowed_to_merge, []) :
        local.group_id_by_fullpath[group] if branch.search_by == "fullpath"
      ]
    )
  }
  unprotect_group_ids = {
    for branch_name, branch in local.all_branches :
    branch_name => concat(
      [
        for group in coalesce(branch.groups_allowed_to_unprotect, []) :
        local.group_id_by_groupid[group] if branch.search_by == "groupid"
      ],
      [
        for group in coalesce(branch.groups_allowed_to_unprotect, []) :
        local.group_id_by_fullpath[group] if branch.search_by == "fullpath"
      ]
    )
  }
}
