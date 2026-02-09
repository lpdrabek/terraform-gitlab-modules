mock_provider "gitlab" {}

run "basic_group" {
  command = plan

  variables {
    groups = {
      "my-group" = {}
    }
  }

  assert {
    condition     = length(gitlab_group.groups) == 1
    error_message = "Should create 1 group"
  }

  assert {
    condition     = length(gitlab_group.create_only_groups) == 0
    error_message = "Should create 0 create_only groups"
  }

  assert {
    condition     = gitlab_group.groups["my-group"].name == "my-group"
    error_message = "Group name should be 'my-group'"
  }

  assert {
    condition     = gitlab_group.groups["my-group"].path == "my-group"
    error_message = "Group path should default to 'my-group'"
  }

  assert {
    condition     = gitlab_group.groups["my-group"].visibility_level == "private"
    error_message = "visibility_level should default to 'private'"
  }

  assert {
    condition     = gitlab_group.groups["my-group"].request_access_enabled == true
    error_message = "request_access_enabled should default to true"
  }

  assert {
    condition     = gitlab_group.groups["my-group"].lfs_enabled == true
    error_message = "lfs_enabled should default to true"
  }
}

run "group_with_custom_path" {
  command = plan

  variables {
    groups = {
      "My Group" = {
        path        = "my-custom-path"
        description = "A test group"
      }
    }
  }

  assert {
    condition     = gitlab_group.groups["My Group"].name == "My Group"
    error_message = "Group name should be 'My Group'"
  }

  assert {
    condition     = gitlab_group.groups["My Group"].path == "my-custom-path"
    error_message = "Group path should be 'my-custom-path'"
  }

  assert {
    condition     = gitlab_group.groups["My Group"].description == "A test group"
    error_message = "Group description should match"
  }
}

run "group_with_visibility" {
  command = plan

  variables {
    groups = {
      "public-group" = {
        visibility_level = "public"
      }
      "internal-group" = {
        visibility_level = "internal"
      }
      "private-group" = {
        visibility_level = "private"
      }
    }
  }

  assert {
    condition     = length(gitlab_group.groups) == 3
    error_message = "Should create 3 groups"
  }

  assert {
    condition     = gitlab_group.groups["public-group"].visibility_level == "public"
    error_message = "public-group visibility should be 'public'"
  }

  assert {
    condition     = gitlab_group.groups["internal-group"].visibility_level == "internal"
    error_message = "internal-group visibility should be 'internal'"
  }

  assert {
    condition     = gitlab_group.groups["private-group"].visibility_level == "private"
    error_message = "private-group visibility should be 'private'"
  }
}

run "group_with_creation_levels" {
  command = plan

  variables {
    groups = {
      "restricted-group" = {
        project_creation_level  = "maintainer"
        subgroup_creation_level = "owner"
      }
    }
  }

  assert {
    condition     = gitlab_group.groups["restricted-group"].project_creation_level == "maintainer"
    error_message = "project_creation_level should be 'maintainer'"
  }

  assert {
    condition     = gitlab_group.groups["restricted-group"].subgroup_creation_level == "owner"
    error_message = "subgroup_creation_level should be 'owner'"
  }
}

run "group_with_security_settings" {
  command = plan

  variables {
    groups = {
      "secure-group" = {
        require_two_factor_authentication = true
        two_factor_grace_period           = 72
        membership_lock                   = true
        share_with_group_lock             = true
        prevent_forking_outside_group     = true
      }
    }
  }

  assert {
    condition     = gitlab_group.groups["secure-group"].require_two_factor_authentication == true
    error_message = "require_two_factor_authentication should be true"
  }

  assert {
    condition     = gitlab_group.groups["secure-group"].two_factor_grace_period == 72
    error_message = "two_factor_grace_period should be 72"
  }

  assert {
    condition     = gitlab_group.groups["secure-group"].membership_lock == true
    error_message = "membership_lock should be true"
  }

  assert {
    condition     = gitlab_group.groups["secure-group"].share_with_group_lock == true
    error_message = "share_with_group_lock should be true"
  }

  assert {
    condition     = gitlab_group.groups["secure-group"].prevent_forking_outside_group == true
    error_message = "prevent_forking_outside_group should be true"
  }
}

run "group_with_feature_settings" {
  command = plan

  variables {
    groups = {
      "feature-group" = {
        auto_devops_enabled = true
        emails_enabled      = false
        mentions_disabled   = true
        wiki_access_level   = "disabled"
      }
    }
  }

  assert {
    condition     = gitlab_group.groups["feature-group"].auto_devops_enabled == true
    error_message = "auto_devops_enabled should be true"
  }

  assert {
    condition     = gitlab_group.groups["feature-group"].emails_enabled == false
    error_message = "emails_enabled should be false"
  }

  assert {
    condition     = gitlab_group.groups["feature-group"].mentions_disabled == true
    error_message = "mentions_disabled should be true"
  }

  assert {
    condition     = gitlab_group.groups["feature-group"].wiki_access_level == "disabled"
    error_message = "wiki_access_level should be 'disabled'"
  }
}

run "create_only_group" {
  command = plan

  variables {
    create_only = true

    groups = {
      "create-only-group" = {
        description      = "A create-only group"
        visibility_level = "internal"
      }
    }
  }

  assert {
    condition     = length(gitlab_group.groups) == 0
    error_message = "Should create 0 normal groups"
  }

  assert {
    condition     = length(gitlab_group.create_only_groups) == 1
    error_message = "Should create 1 create_only group"
  }

  assert {
    condition     = gitlab_group.create_only_groups["create-only-group"].name == "create-only-group"
    error_message = "create_only group name should be 'create-only-group'"
  }

  assert {
    condition     = gitlab_group.create_only_groups["create-only-group"].visibility_level == "internal"
    error_message = "create_only group visibility should be 'internal'"
  }
}

run "multiple_groups" {
  command = plan

  variables {
    groups = {
      "group-1" = {
        description = "First group"
      }
      "group-2" = {
        description = "Second group"
      }
      "group-3" = {
        description = "Third group"
      }
    }
  }

  assert {
    condition     = length(gitlab_group.groups) == 3
    error_message = "Should create 3 groups"
  }

  assert {
    condition     = gitlab_group.groups["group-1"].description == "First group"
    error_message = "group-1 description should match"
  }

  assert {
    condition     = gitlab_group.groups["group-2"].description == "Second group"
    error_message = "group-2 description should match"
  }

  assert {
    condition     = gitlab_group.groups["group-3"].description == "Third group"
    error_message = "group-3 description should match"
  }
}

run "empty_groups" {
  command = plan

  variables {
    groups = {}
  }

  assert {
    condition     = length(gitlab_group.groups) == 0
    error_message = "Should create 0 groups when groups is empty"
  }

  assert {
    condition     = length(gitlab_group.create_only_groups) == 0
    error_message = "Should create 0 create_only groups when groups is empty"
  }
}

run "group_with_shared_runners" {
  command = plan

  variables {
    groups = {
      "runners-group" = {
        shared_runners_setting = "disabled_and_overridable"
      }
    }
  }

  assert {
    condition     = gitlab_group.groups["runners-group"].shared_runners_setting == "disabled_and_overridable"
    error_message = "shared_runners_setting should be 'disabled_and_overridable'"
  }
}

run "group_with_deploy_tokens" {
  command = plan

  variables {
    groups = {
      "group-with-tokens" = {
        description = "Group with deploy tokens"

        deploy_tokens = {
          "token1" = {
            scopes   = ["read_registry"]
            username = "t1user"
          }
          "token2" = {
            scopes     = ["read_package_registry", "write_package_registry"]
            username   = "t2user"
            expires_at = "2026-12-31T23:59:59Z"
          }
        }
      }
    }
  }

  assert {
    condition     = length(gitlab_group.groups) == 1
    error_message = "Should create 1 group"
  }

  assert {
    condition     = length(module.deploy_tokens["group-with-tokens"].tokens) == 2
    error_message = "Should create 2 deploy tokens for the group"
  }
}


run "group_with_project_deploy_tokens" {
  command = plan

  variables {
    groups = {
      "group-with-project-tokens" = {
        description = "Group with project that has deploy tokens"

        projects = {
          "project1" = {
            description = "API service"

            deploy_tokens = {
              "token1" = {
                scopes   = ["read_repository", "read_registry"]
                username = "t1user"
              }
            }
          }
        }
      }
    }
  }

  assert {
    condition     = length(gitlab_group.groups) == 1
    error_message = "Should create 1 group"
  }

  assert {
    condition     = length(module.projects) == 1
    error_message = "Should create projects module for the group"
  }
}
