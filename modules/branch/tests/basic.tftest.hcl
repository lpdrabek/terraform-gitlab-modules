mock_provider "gitlab" {}

run "basic_branch" {
  command = plan

  variables {
    project = "123"

    branches = {
      "develop" = {
        create_from = "main"
      }
    }
  }

  assert {
    condition     = length(gitlab_branch.project_branch) == 1
    error_message = "Should create 1 branch"
  }

  assert {
    condition     = gitlab_branch.project_branch["develop"].name == "develop"
    error_message = "Branch name should be 'develop'"
  }

  assert {
    condition     = gitlab_branch.project_branch["develop"].ref == "main"
    error_message = "Branch should be created from 'main'"
  }

  assert {
    condition     = gitlab_branch.project_branch["develop"].project == "123"
    error_message = "Branch should belong to project '123'"
  }
}

run "multiple_branches" {
  command = plan

  variables {
    project = "456"

    branches = {
      "develop" = {
        create_from = "main"
      }
      "staging" = {
        create_from = "main"
      }
      "feature/auth" = {
        create_from = "develop"
      }
    }
  }

  assert {
    condition     = length(gitlab_branch.project_branch) == 3
    error_message = "Should create 3 branches"
  }

  assert {
    condition     = gitlab_branch.project_branch["develop"].ref == "main"
    error_message = "develop should be created from 'main'"
  }

  assert {
    condition     = gitlab_branch.project_branch["staging"].ref == "main"
    error_message = "staging should be created from 'main'"
  }

  assert {
    condition     = gitlab_branch.project_branch["feature/auth"].ref == "develop"
    error_message = "feature/auth should be created from 'develop'"
  }
}
