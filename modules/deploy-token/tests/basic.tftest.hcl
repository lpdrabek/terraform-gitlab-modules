mock_provider "gitlab" {}

run "basic_project_deploy_token" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    tokens = {
      "my-deploy-token" = {
        scopes = ["read_repository", "read_registry"]
      }
    }
  }

  assert {
    condition     = length(gitlab_project_deploy_token.project_tokens) == 1
    error_message = "Should create 1 project deploy token"
  }

  assert {
    condition     = length(gitlab_project_deploy_token.create_only_project_tokens) == 0
    error_message = "Should create 0 create_only project deploy tokens"
  }

  assert {
    condition     = length(gitlab_group_deploy_token.group_tokens) == 0
    error_message = "Should create 0 group deploy tokens"
  }

  assert {
    condition     = gitlab_project_deploy_token.project_tokens["my-deploy-token"].project == "123"
    error_message = "Deploy token should be for project 123"
  }

  assert {
    condition     = gitlab_project_deploy_token.project_tokens["my-deploy-token"].name == "my-deploy-token"
    error_message = "Token name should be 'my-deploy-token'"
  }

  assert {
    condition     = contains(gitlab_project_deploy_token.project_tokens["my-deploy-token"].scopes, "read_repository")
    error_message = "Token should have read_repository scope"
  }
}

run "basic_group_deploy_token" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "my-group"
    }

    tokens = {
      "group-deploy-token" = {
        scopes   = ["read_registry", "write_registry"]
        username = "custom-username"
      }
    }
  }

  assert {
    condition     = length(gitlab_group_deploy_token.group_tokens) == 1
    error_message = "Should create 1 group deploy token"
  }

  assert {
    condition     = length(gitlab_project_deploy_token.project_tokens) == 0
    error_message = "Should create 0 project deploy tokens"
  }

  assert {
    condition     = gitlab_group_deploy_token.group_tokens["group-deploy-token"].group == "my-group"
    error_message = "Deploy token should be for group my-group"
  }

  assert {
    condition     = gitlab_group_deploy_token.group_tokens["group-deploy-token"].username == "custom-username"
    error_message = "Token should have custom username"
  }
}

run "create_only_mode" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "456"
    }

    create_only = true

    tokens = {
      "create-only-token" = {
        scopes = ["read_repository"]
      }
    }
  }

  assert {
    condition     = length(gitlab_project_deploy_token.project_tokens) == 0
    error_message = "Should create 0 normal project deploy tokens"
  }

  assert {
    condition     = length(gitlab_project_deploy_token.create_only_project_tokens) == 1
    error_message = "Should create 1 create_only project deploy token"
  }

  assert {
    condition     = gitlab_project_deploy_token.create_only_project_tokens["create-only-token"].project == "456"
    error_message = "Create-only deploy token should be for project 456"
  }
}

run "token_with_expiration" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "789"
    }

    tokens = {
      "expiring-token" = {
        scopes     = ["read_package_registry"]
        expires_at = "2025-12-31T23:59:59Z"
      }
    }
  }

  assert {
    condition     = gitlab_project_deploy_token.project_tokens["expiring-token"].expires_at == "2025-12-31T23:59:59Z"
    error_message = "Token should have correct expiration date"
  }
}
