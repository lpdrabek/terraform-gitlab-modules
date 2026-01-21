mock_provider "gitlab" {
  mock_data "gitlab_user" {
    defaults = {
      id = 12345 # forcing a number - gitlab's data source says userid is a string so tests generate a string
    }
  }
}

run "group_membership_by_userid" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "123"
    }

    membership = {
      "developer" = {
        users      = ["42", "43"]
        find_users = "userid"
      }
    }
  }

  assert {
    condition     = length(data.gitlab_user.userid_lookup) == 2
    error_message = "Should lookup 2 users by userid"
  }

  assert {
    condition     = length(data.gitlab_user.email_lookup) == 0
    error_message = "Should not lookup users by email"
  }

  assert {
    condition     = length(data.gitlab_user.username_lookup) == 0
    error_message = "Should not lookup users by username"
  }
}

run "group_membership_by_email" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "456"
    }

    membership = {
      "maintainer" = {
        users      = ["user1@example.com", "user2@example.com"]
        find_users = "email"
      }
    }
  }

  assert {
    condition     = length(data.gitlab_user.email_lookup) == 2
    error_message = "Should lookup 2 users by email"
  }

  assert {
    condition     = length(data.gitlab_user.userid_lookup) == 0
    error_message = "Should not lookup users by userid"
  }

  assert {
    condition     = length(data.gitlab_user.username_lookup) == 0
    error_message = "Should not lookup users by username"
  }
}

run "group_membership_by_username" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "789"
    }

    membership = {
      "developer" = {
        users      = ["jsmith", "jdoe"]
        find_users = "username"
      }
    }
  }

  assert {
    condition     = length(data.gitlab_user.username_lookup) == 2
    error_message = "Should lookup 2 users by username"
  }

  assert {
    condition     = length(data.gitlab_user.email_lookup) == 0
    error_message = "Should not lookup users by email"
  }

  assert {
    condition     = length(data.gitlab_user.userid_lookup) == 0
    error_message = "Should not lookup users by userid"
  }
}

run "project_membership_by_userid" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    membership = {
      "reporter" = {
        users      = ["100"]
        find_users = "userid"
      }
    }
  }

  assert {
    condition     = length(data.gitlab_user.userid_lookup) == 1
    error_message = "Should lookup 1 user by userid"
  }
}

run "membership_with_expiration" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "123"
    }

    membership = {
      "guest" = {
        users      = ["temp@example.com"]
        find_users = "email"
        expires_at = "2026-12-31"
      }
    }
  }

  assert {
    condition     = length(data.gitlab_user.email_lookup) == 1
    error_message = "Should lookup 1 user by email"
  }
}

run "multiple_access_levels" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "123"
    }

    membership = {
      "developer" = {
        users      = ["10", "11"]
        find_users = "userid"
      }
      "maintainer" = {
        users      = ["20"]
        find_users = "userid"
      }
      "owner" = {
        users      = ["30"]
        find_users = "userid"
      }
    }
  }

  assert {
    condition     = length(data.gitlab_user.userid_lookup) == 4
    error_message = "Should lookup 4 users total by userid"
  }
}

run "empty_membership" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "123"
    }

    membership = {}
  }

  assert {
    condition     = length(data.gitlab_user.email_lookup) == 0
    error_message = "Should not lookup any users by email when membership is empty"
  }

  assert {
    condition     = length(data.gitlab_user.userid_lookup) == 0
    error_message = "Should not lookup any users by userid when membership is empty"
  }

  assert {
    condition     = length(data.gitlab_user.username_lookup) == 0
    error_message = "Should not lookup any users by username when membership is empty"
  }

  assert {
    condition     = length(gitlab_group_membership.members) == 0
    error_message = "Should not create any group memberships when membership is empty"
  }

  assert {
    condition     = length(gitlab_project_membership.members) == 0
    error_message = "Should not create any project memberships when membership is empty"
  }
}

run "default_find_users_is_email" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    membership = {
      "developer" = {
        users = ["user@example.com"]
      }
    }
  }

  assert {
    condition     = length(data.gitlab_user.email_lookup) == 1
    error_message = "Should default to email lookup when find_users not specified"
  }
}
