mock_provider "gitlab" {}

run "basic_deploy_key" {
  command = plan

  variables {
    project = "123"

    deploy_keys = {
      "my-deploy-key" = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample"
      }
    }
  }

  assert {
    condition     = length(gitlab_deploy_key.deploy_keys) == 1
    error_message = "Should create 1 deploy key"
  }

  assert {
    condition     = length(gitlab_deploy_key.create_only_deploy_keys) == 0
    error_message = "Should create 0 create_only deploy keys"
  }

  assert {
    condition     = length(gitlab_deploy_key_enable.enable_keys) == 0
    error_message = "Should enable 0 deploy keys"
  }

  assert {
    condition     = gitlab_deploy_key.deploy_keys["my-deploy-key"].project == "123"
    error_message = "Deploy key should be for project 123"
  }

  assert {
    condition     = gitlab_deploy_key.deploy_keys["my-deploy-key"].title == "my-deploy-key"
    error_message = "Deploy key title should be 'my-deploy-key'"
  }

  assert {
    condition     = gitlab_deploy_key.deploy_keys["my-deploy-key"].key == "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample"
    error_message = "Deploy key should have correct public key"
  }
}

run "deploy_key_with_options" {
  command = plan

  variables {
    project = "456"

    deploy_keys = {
      "push-key" = {
        key        = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample2"
        can_push   = true
        expires_at = "2026-12-31T23:59:59Z"
      }
    }
  }

  assert {
    condition     = gitlab_deploy_key.deploy_keys["push-key"].can_push == true
    error_message = "Deploy key should have push access"
  }

  assert {
    condition     = gitlab_deploy_key.deploy_keys["push-key"].expires_at == "2026-12-31T23:59:59Z"
    error_message = "Deploy key should have correct expiration date"
  }
}

run "create_only_mode" {
  command = plan

  variables {
    project     = "789"
    create_only = true

    deploy_keys = {
      "create-only-key" = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample3"
      }
    }
  }

  assert {
    condition     = length(gitlab_deploy_key.deploy_keys) == 0
    error_message = "Should create 0 normal deploy keys"
  }

  assert {
    condition     = length(gitlab_deploy_key.create_only_deploy_keys) == 1
    error_message = "Should create 1 create_only deploy key"
  }

  assert {
    condition     = gitlab_deploy_key.create_only_deploy_keys["create-only-key"].project == "789"
    error_message = "Create-only deploy key should be for project 789"
  }
}

run "enable_existing_key" {
  command = plan

  variables {
    project = "101"

    deploy_keys = {
      "shared-key" = {
        key_id = "42"
        enable = ["project-b"]
      }
    }
  }

  assert {
    condition     = length(gitlab_deploy_key.deploy_keys) == 0
    error_message = "Should create 0 deploy keys"
  }

  assert {
    condition     = length(gitlab_deploy_key_enable.enable_keys) == 1
    error_message = "Should enable 1 deploy key"
  }

  assert {
    condition     = gitlab_deploy_key_enable.enable_keys["shared-key:project-b"].project == "project-b"
    error_message = "Enabled key should be for project-b"
  }

  assert {
    condition     = gitlab_deploy_key_enable.enable_keys["shared-key:project-b"].key_id == "42"
    error_message = "Enabled key should reference key_id 42"
  }
}

run "enable_on_multiple_projects" {
  command = plan

  variables {
    project = "101"

    deploy_keys = {
      "shared-key" = {
        key_id = "42"
        enable = ["project-b", "project-c", "project-d"]
      }
    }
  }

  assert {
    condition     = length(gitlab_deploy_key_enable.enable_keys) == 3
    error_message = "Should enable on 3 projects"
  }

  assert {
    condition     = gitlab_deploy_key_enable.enable_keys["shared-key:project-b"].project == "project-b"
    error_message = "Should enable on project-b"
  }

  assert {
    condition     = gitlab_deploy_key_enable.enable_keys["shared-key:project-c"].project == "project-c"
    error_message = "Should enable on project-c"
  }

  assert {
    condition     = gitlab_deploy_key_enable.enable_keys["shared-key:project-d"].project == "project-d"
    error_message = "Should enable on project-d"
  }
}

run "create_and_enable" {
  command = plan

  variables {
    project = "101"

    deploy_keys = {
      "ci-key" = {
        key    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICreate"
        enable = ["project-b", "project-c"]
      }
    }
  }

  assert {
    condition     = length(gitlab_deploy_key.deploy_keys) == 1
    error_message = "Should create 1 deploy key"
  }

  assert {
    condition     = gitlab_deploy_key.deploy_keys["ci-key"].project == "101"
    error_message = "Deploy key should be created on project 101"
  }

  assert {
    condition     = length(gitlab_deploy_key_enable.enable_keys) == 2
    error_message = "Should enable on 2 additional projects"
  }

  assert {
    condition     = gitlab_deploy_key_enable.enable_keys["ci-key:project-b"].project == "project-b"
    error_message = "Should enable on project-b"
  }

  assert {
    condition     = gitlab_deploy_key_enable.enable_keys["ci-key:project-c"].project == "project-c"
    error_message = "Should enable on project-c"
  }
}

run "mixed_create_enable_and_existing" {
  command = plan

  variables {
    project = "101"

    deploy_keys = {
      "new-key" = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINewKey"
      }
      "new-shared-key" = {
        key    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIShared"
        enable = ["project-b"]
      }
      "existing-key" = {
        key_id = "55"
        enable = ["project-c"]
      }
    }
  }

  assert {
    condition     = length(gitlab_deploy_key.deploy_keys) == 2
    error_message = "Should create 2 deploy keys"
  }

  assert {
    condition     = length(gitlab_deploy_key_enable.enable_keys) == 2
    error_message = "Should enable 2 deploy keys"
  }

  assert {
    condition     = gitlab_deploy_key_enable.enable_keys["existing-key:project-c"].key_id == "55"
    error_message = "Existing key should reference key_id 55"
  }
}

run "multiple_deploy_keys" {
  command = plan

  variables {
    project = "404"

    deploy_keys = {
      "read-only-key" = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIReadOnly"
      }
      "push-key" = {
        key      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPush"
        can_push = true
      }
    }
  }

  assert {
    condition     = length(gitlab_deploy_key.deploy_keys) == 2
    error_message = "Should create 2 deploy keys"
  }
}
