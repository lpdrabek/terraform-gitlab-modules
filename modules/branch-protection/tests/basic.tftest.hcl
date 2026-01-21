mock_provider "gitlab" {}

run "basic_branch_protection" {
  command = plan

  variables {
    project = "123"

    branches = {
      "main" = {}
    }
  }

  assert {
    condition     = length(gitlab_branch_protection.branches) == 1
    error_message = "Should create 1 branch protection"
  }

  assert {
    condition     = length(gitlab_branch_protection.create_only_branches) == 0
    error_message = "Should create 0 create_only branch protections"
  }

  assert {
    condition     = gitlab_branch_protection.branches["main"].project == "123"
    error_message = "Branch protection should be for project 123"
  }

  assert {
    condition     = gitlab_branch_protection.branches["main"].branch == "main"
    error_message = "Branch name should be 'main'"
  }

  assert {
    condition     = gitlab_branch_protection.branches["main"].allow_force_push == false
    error_message = "allow_force_push should default to false"
  }

  assert {
    condition     = gitlab_branch_protection.branches["main"].code_owner_approval_required == false
    error_message = "code_owner_approval_required should default to false"
  }
}

run "branch_protection_with_access_levels" {
  command = plan

  variables {
    project = "456"

    branches = {
      "main" = {
        push_access_level      = "maintainer"
        merge_access_level     = "developer"
        unprotect_access_level = "maintainer"
      }
    }
  }

  assert {
    condition     = gitlab_branch_protection.branches["main"].push_access_level == "maintainer"
    error_message = "push_access_level should be 'maintainer'"
  }

  assert {
    condition     = gitlab_branch_protection.branches["main"].merge_access_level == "developer"
    error_message = "merge_access_level should be 'developer'"
  }

  assert {
    condition     = gitlab_branch_protection.branches["main"].unprotect_access_level == "maintainer"
    error_message = "unprotect_access_level should be 'maintainer'"
  }
}

run "branch_protection_with_force_push" {
  command = plan

  variables {
    project = "789"

    branches = {
      "develop" = {
        allow_force_push             = true
        code_owner_approval_required = true
      }
    }
  }

  assert {
    condition     = gitlab_branch_protection.branches["develop"].allow_force_push == true
    error_message = "allow_force_push should be true"
  }

  assert {
    condition     = gitlab_branch_protection.branches["develop"].code_owner_approval_required == true
    error_message = "code_owner_approval_required should be true"
  }
}

run "multiple_branch_protections" {
  command = plan

  variables {
    project = "123"

    branches = {
      "main" = {
        push_access_level  = "maintainer"
        merge_access_level = "maintainer"
      }
      "develop" = {
        push_access_level  = "developer"
        merge_access_level = "developer"
      }
      "release/*" = {
        push_access_level  = "no one"
        merge_access_level = "maintainer"
      }
    }
  }

  assert {
    condition     = length(gitlab_branch_protection.branches) == 3
    error_message = "Should create 3 branch protections"
  }

  assert {
    condition     = gitlab_branch_protection.branches["main"].push_access_level == "maintainer"
    error_message = "main branch push_access_level should be 'maintainer'"
  }

  assert {
    condition     = gitlab_branch_protection.branches["develop"].push_access_level == "developer"
    error_message = "develop branch push_access_level should be 'developer'"
  }

  assert {
    condition     = gitlab_branch_protection.branches["release/*"].push_access_level == "no one"
    error_message = "release/* branch push_access_level should be 'no one'"
  }
}

run "create_only_branch_protection" {
  command = plan

  variables {
    project     = "123"
    create_only = true

    branches = {
      "main" = {
        push_access_level  = "maintainer"
        merge_access_level = "developer"
      }
    }
  }

  assert {
    condition     = length(gitlab_branch_protection.branches) == 0
    error_message = "Should create 0 normal branch protections"
  }

  assert {
    condition     = length(gitlab_branch_protection.create_only_branches) == 1
    error_message = "Should create 1 create_only branch protection"
  }

  assert {
    condition     = gitlab_branch_protection.create_only_branches["main"].project == "123"
    error_message = "create_only branch protection should be for project 123"
  }

  assert {
    condition     = gitlab_branch_protection.create_only_branches["main"].push_access_level == "maintainer"
    error_message = "create_only branch push_access_level should be 'maintainer'"
  }
}

run "empty_branches" {
  command = plan

  variables {
    project  = "123"
    branches = {}
  }

  assert {
    condition     = length(gitlab_branch_protection.branches) == 0
    error_message = "Should create 0 branch protections when branches is empty"
  }

  assert {
    condition     = length(gitlab_branch_protection.create_only_branches) == 0
    error_message = "Should create 0 create_only branch protections when branches is empty"
  }
}
