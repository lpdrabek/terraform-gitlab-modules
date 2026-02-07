mock_provider "gitlab" {}

run "project_runner_basic" {
  command = plan

  variables {
    runners = {
      "docker-runner" = {
        runner_type  = "project_type"
        project_id   = 123
        description  = "Docker runner"
        tag_list     = ["docker", "linux"]
        access_level = "not_protected"
      }
    }
  }

  assert {
    condition     = length(gitlab_user_runner.runner) == 1
    error_message = "Should create 1 runner"
  }

  assert {
    condition     = length(gitlab_user_runner.create_only_runner) == 0
    error_message = "Should not create create_only runners when create_only is false"
  }

  assert {
    condition     = gitlab_user_runner.runner["docker-runner"].runner_type == "project_type"
    error_message = "Runner type should be 'project_type'"
  }

  assert {
    condition     = gitlab_user_runner.runner["docker-runner"].project_id == 123
    error_message = "Runner should be associated with project 123"
  }

  assert {
    condition     = gitlab_user_runner.runner["docker-runner"].description == "Docker runner"
    error_message = "Runner description should match"
  }

  assert {
    condition     = gitlab_user_runner.runner["docker-runner"].access_level == "not_protected"
    error_message = "Runner access_level should be 'not_protected'"
  }

  assert {
    condition     = contains(gitlab_user_runner.runner["docker-runner"].tag_list, "docker")
    error_message = "Runner should have 'docker' tag"
  }

  assert {
    condition     = contains(gitlab_user_runner.runner["docker-runner"].tag_list, "linux")
    error_message = "Runner should have 'linux' tag"
  }
}

run "group_runner_basic" {
  command = plan

  variables {
    runners = {
      "shared-runner" = {
        runner_type      = "group_type"
        group_id         = 456
        description      = "Shared runner"
        tag_list         = ["shared", "docker"]
        access_level     = "ref_protected"
        untagged         = true
        maintenance_note = "Shared runner"
      }
    }
  }

  assert {
    condition     = length(gitlab_user_runner.runner) == 1
    error_message = "Should create 1 runner"
  }

  assert {
    condition     = gitlab_user_runner.runner["shared-runner"].runner_type == "group_type"
    error_message = "Runner type should be 'group_type'"
  }

  assert {
    condition     = gitlab_user_runner.runner["shared-runner"].group_id == 456
    error_message = "Runner should be associated with group 456"
  }

  assert {
    condition     = gitlab_user_runner.runner["shared-runner"].access_level == "ref_protected"
    error_message = "Runner access_level should be 'ref_protected'"
  }

  assert {
    condition     = gitlab_user_runner.runner["shared-runner"].untagged == true
    error_message = "Runner should handle untagged jobs"
  }

  assert {
    condition     = gitlab_user_runner.runner["shared-runner"].maintenance_note == "Shared runner"
    error_message = "Runner maintenance_note should match"
  }
}

run "instance_runner_basic" {
  command = plan

  variables {
    runners = {
      "global-runner" = {
        runner_type      = "instance_type"
        description      = "Global runner"
        tag_list         = ["global", "docker"]
        access_level     = "not_protected"
        untagged         = true
        maintenance_note = "Global runner"
      }
    }
  }

  assert {
    condition     = length(gitlab_user_runner.runner) == 1
    error_message = "Should create 1 runner"
  }

  assert {
    condition     = gitlab_user_runner.runner["global-runner"].runner_type == "instance_type"
    error_message = "Runner type should be 'instance_type'"
  }

  assert {
    condition     = gitlab_user_runner.runner["global-runner"].project_id == null
    error_message = "Instance runner should not have project_id"
  }

  assert {
    condition     = gitlab_user_runner.runner["global-runner"].group_id == null
    error_message = "Instance runner should not have group_id"
  }
}

run "multiple_runners" {
  command = plan

  variables {
    runners = {
      "docker-runner" = {
        runner_type  = "project_type"
        project_id   = 123
        description  = "Docker"
        tag_list     = ["docker"]
        access_level = "not_protected"
      }
      "shared-runner" = {
        runner_type  = "project_type"
        project_id   = 234
        description  = "Shell"
        tag_list     = ["shared"]
        access_level = "ref_protected"
        locked       = true
      }
      "k8s-runner" = {
        runner_type     = "project_type"
        project_id      = 345
        description     = "Kubernetes"
        tag_list        = ["kubernetes", "k8s"]
        access_level    = "ref_protected"
        maximum_timeout = 7200
      }
    }
  }

  assert {
    condition     = length(gitlab_user_runner.runner) == 3
    error_message = "Should create 3 runners"
  }

  assert {
    condition     = gitlab_user_runner.runner["docker-runner"].description == "Docker"
    error_message = "Docker runner description should match"
  }

  assert {
    condition     = gitlab_user_runner.runner["shared-runner"].locked == true
    error_message = "Shell runner should be locked"
  }

  assert {
    condition     = gitlab_user_runner.runner["k8s-runner"].maximum_timeout == 7200
    error_message = "K8s runner maximum_timeout should be 7200"
  }
}

run "create_only_mode" {
  command = plan

  variables {
    create_only = true

    runners = {
      "immutable-runner" = {
        runner_type = "project_type"
        project_id  = 123
        description = "Immutable runner"
        tag_list    = ["immutable"]
      }
    }
  }

  assert {
    condition     = length(gitlab_user_runner.runner) == 0
    error_message = "Should not create regular runners when create_only is true"
  }

  assert {
    condition     = length(gitlab_user_runner.create_only_runner) == 1
    error_message = "Should create 1 create_only runner"
  }

  assert {
    condition     = gitlab_user_runner.create_only_runner["immutable-runner"].runner_type == "project_type"
    error_message = "Create-only runner type should be 'project_type'"
  }

  assert {
    condition     = gitlab_user_runner.create_only_runner["immutable-runner"].project_id == 123
    error_message = "Create-only runner should be associated with project 123"
  }
}
