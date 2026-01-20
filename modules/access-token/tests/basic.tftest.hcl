mock_provider "gitlab" {}

run "project_access_token_basic" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    access_tokens = {
      "deploy-token" = {
        scopes       = ["read_repository", "write_repository"]
        access_level = "maintainer"
        description  = "Deploy Token description"
        expires_at   = "2026-12-31"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_access_token.tokens) == 1
    error_message = "Should create one project access token"
  }

  assert {
    condition     = length(gitlab_group_access_token.tokens) == 0
    error_message = "Should not create group access tokens"
  }

  assert {
    condition     = length(gitlab_personal_access_token.tokens) == 0
    error_message = "Should not create personal access tokens"
  }

  assert {
    condition     = gitlab_project_access_token.tokens["deploy-token"].name == "deploy-token"
    error_message = "Token name should match the key"
  }

  assert {
    condition     = gitlab_project_access_token.tokens["deploy-token"].project == "123"
    error_message = "Token should be associated with the correct project"
  }

  assert {
    condition     = gitlab_project_access_token.tokens["deploy-token"].access_level == "maintainer"
    error_message = "Token should have maintainer access level"
  }

  assert {
    condition     = gitlab_project_access_token.tokens["deploy-token"].description == "Deploy Token description"
    error_message = "Token should have correct description"
  }

  assert {
    condition     = gitlab_project_access_token.tokens["deploy-token"].expires_at == "2026-12-31"
    error_message = "Token should have correct expiration date"
  }

  assert {
    condition     = contains(gitlab_project_access_token.tokens["deploy-token"].scopes, "read_repository")
    error_message = "Token should have read_repository scope"
  }

  assert {
    condition     = contains(gitlab_project_access_token.tokens["deploy-token"].scopes, "write_repository")
    error_message = "Token should have write_repository scope"
  }
}

run "project_access_token_default_access_level" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "456"
    }

    access_tokens = {
      "ci-token" = {
        scopes     = ["read_api"]
        expires_at = "2027-06-30"
      }
    }
  }

  assert {
    condition     = gitlab_project_access_token.tokens["ci-token"].access_level == "maintainer"
    error_message = "Token should default to maintainer access level"
  }
}


run "group_access_token_basic" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "789"
    }

    access_tokens = {
      "group-deploy-token" = {
        scopes       = ["read_repository", "read_registry"]
        access_level = "developer"
        description  = "Group deployment token"
        expires_at   = "2026-12-31"
      }
    }
  }

  assert {
    condition     = length(gitlab_group_access_token.tokens) == 1
    error_message = "Should create one group access token"
  }

  assert {
    condition     = length(gitlab_project_access_token.tokens) == 0
    error_message = "Should not create project access tokens"
  }

  assert {
    condition     = length(gitlab_personal_access_token.tokens) == 0
    error_message = "Should not create personal access tokens"
  }

  assert {
    condition     = gitlab_group_access_token.tokens["group-deploy-token"].name == "group-deploy-token"
    error_message = "Token name should match the key"
  }

  assert {
    condition     = gitlab_group_access_token.tokens["group-deploy-token"].group == "789"
    error_message = "Token should be associated with the correct group"
  }

  assert {
    condition     = gitlab_group_access_token.tokens["group-deploy-token"].access_level == "developer"
    error_message = "Token should have developer access level"
  }

  assert {
    condition     = contains(gitlab_group_access_token.tokens["group-deploy-token"].scopes, "read_repository")
    error_message = "Token should have read_repository scope"
  }

  assert {
    condition     = contains(gitlab_group_access_token.tokens["group-deploy-token"].scopes, "read_registry")
    error_message = "Token should have read_registry scope"
  }
}


run "personal_access_token_basic" {
  command = plan

  variables {
    target = {
      type = "personal"
      id   = "42"
    }

    access_tokens = {
      "my-pat" = {
        scopes      = ["api", "read_user"]
        description = "Personal access token for API"
        expires_at  = "2026-12-31"
      }
    }
  }

  assert {
    condition     = length(gitlab_personal_access_token.tokens) == 1
    error_message = "Should create one personal access token"
  }

  assert {
    condition     = length(gitlab_project_access_token.tokens) == 0
    error_message = "Should not create project access tokens"
  }

  assert {
    condition     = length(gitlab_group_access_token.tokens) == 0
    error_message = "Should not create group access tokens"
  }

  assert {
    condition     = gitlab_personal_access_token.tokens["my-pat"].name == "my-pat"
    error_message = "Token name should match the key"
  }

  assert {
    condition     = gitlab_personal_access_token.tokens["my-pat"].user_id == 42
    error_message = "Token should be associated with the correct user"
  }

  assert {
    condition     = contains(gitlab_personal_access_token.tokens["my-pat"].scopes, "api")
    error_message = "Token should have api scope"
  }

  assert {
    condition     = contains(gitlab_personal_access_token.tokens["my-pat"].scopes, "read_user")
    error_message = "Token should have read_user scope"
  }
}


run "multiple_tokens" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "999"
    }

    access_tokens = {
      "deploy-token" = {
        scopes       = ["read_repository", "write_repository"]
        access_level = "maintainer"
        expires_at   = "2026-12-31"
      }
      "ci-token" = {
        scopes       = ["read_api", "read_registry"]
        access_level = "developer"
        expires_at   = "2027-01-15"
      }
      "readonly-token" = {
        scopes       = ["read_repository"]
        access_level = "reporter"
        description  = "Read-only access"
        expires_at   = "2026-06-30"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_access_token.tokens) == 3
    error_message = "Should create three project access tokens"
  }

  assert {
    condition     = gitlab_project_access_token.tokens["deploy-token"].access_level == "maintainer"
    error_message = "deploy-token should have maintainer access"
  }

  assert {
    condition     = gitlab_project_access_token.tokens["ci-token"].access_level == "developer"
    error_message = "ci-token should have developer access"
  }

  assert {
    condition     = gitlab_project_access_token.tokens["readonly-token"].access_level == "reporter"
    error_message = "readonly-token should have reporter access"
  }

  assert {
    condition     = gitlab_project_access_token.tokens["readonly-token"].description == "Read-only access"
    error_message = "readonly-token should have correct description"
  }
}                                                                                                                                                                                                                                                                                   