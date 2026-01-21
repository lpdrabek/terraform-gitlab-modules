mock_provider "gitlab" {}

run "push_mirror_basic" {
  command = plan

  variables {
    type = "push"

    target = {
      "123" = {
        url = "https://github.com/example/repo.git"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_push_mirror.push_target) == 1
    error_message = "Should create 1 push mirror"
  }

  assert {
    condition     = length(gitlab_project_pull_mirror.pull_target) == 0
    error_message = "Should create 0 pull mirrors"
  }

  assert {
    condition     = gitlab_project_push_mirror.push_target["123"].project == "123"
    error_message = "Push mirror should be for project 123"
  }

  assert {
    condition     = gitlab_project_push_mirror.push_target["123"].url == "https://github.com/example/repo.git"
    error_message = "Push mirror URL should match"
  }

  assert {
    condition     = gitlab_project_push_mirror.push_target["123"].enabled == true
    error_message = "Push mirror should be enabled by default"
  }
}

run "pull_mirror_basic" {
  command = plan

  variables {
    type = "pull"

    target = {
      "456" = {
        url = "https://github.com/example/source.git"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_push_mirror.push_target) == 0
    error_message = "Should create 0 push mirrors"
  }

  assert {
    condition     = length(gitlab_project_pull_mirror.pull_target) == 1
    error_message = "Should create 1 pull mirror"
  }

  assert {
    condition     = gitlab_project_pull_mirror.pull_target["456"].project == "456"
    error_message = "Pull mirror should be for project 456"
  }

  assert {
    condition     = gitlab_project_pull_mirror.pull_target["456"].url == "https://github.com/example/source.git"
    error_message = "Pull mirror URL should match"
  }

  assert {
    condition     = gitlab_project_pull_mirror.pull_target["456"].enabled == true
    error_message = "Pull mirror should be enabled by default"
  }
}

run "push_mirror_with_options" {
  command = plan

  variables {
    type = "push"

    target = {
      "123" = {
        url                     = "https://github.com/example/repo.git"
        auth_method             = "password"
        enabled                 = true
        keep_divergent_refs     = true
        only_protected_branches = true
      }
    }
  }

  assert {
    condition     = gitlab_project_push_mirror.push_target["123"].auth_method == "password"
    error_message = "Push mirror auth_method should be 'password'"
  }

  assert {
    condition     = gitlab_project_push_mirror.push_target["123"].keep_divergent_refs == true
    error_message = "Push mirror keep_divergent_refs should be true"
  }

  assert {
    condition     = gitlab_project_push_mirror.push_target["123"].only_protected_branches == true
    error_message = "Push mirror only_protected_branches should be true"
  }
}

run "pull_mirror_with_auth" {
  command = plan

  variables {
    type = "pull"

    target = {
      "789" = {
        url           = "https://github.com/example/private-repo.git"
        auth_user     = "deploy-token"
        auth_password = "secret-token"
      }
    }
  }

  assert {
    condition     = gitlab_project_pull_mirror.pull_target["789"].auth_user == "deploy-token"
    error_message = "Pull mirror auth_user should match"
  }

  assert {
    condition     = gitlab_project_pull_mirror.pull_target["789"].auth_password == "secret-token"
    error_message = "Pull mirror auth_password should match"
  }
}

run "pull_mirror_with_options" {
  command = plan

  variables {
    type = "pull"

    target = {
      "456" = {
        url                                 = "https://github.com/example/source.git"
        mirror_overwrites_diverged_branches = true
        mirror_trigger_builds               = true
        only_mirror_protected_branches      = true
      }
    }
  }

  assert {
    condition     = gitlab_project_pull_mirror.pull_target["456"].mirror_overwrites_diverged_branches == true
    error_message = "Pull mirror mirror_overwrites_diverged_branches should be true"
  }

  assert {
    condition     = gitlab_project_pull_mirror.pull_target["456"].mirror_trigger_builds == true
    error_message = "Pull mirror mirror_trigger_builds should be true"
  }

  assert {
    condition     = gitlab_project_pull_mirror.pull_target["456"].only_mirror_protected_branches == true
    error_message = "Pull mirror only_mirror_protected_branches should be true"
  }
}

run "push_mirror_disabled" {
  command = plan

  variables {
    type = "push"

    target = {
      "123" = {
        url     = "https://github.com/example/repo.git"
        enabled = false
      }
    }
  }

  assert {
    condition     = gitlab_project_push_mirror.push_target["123"].enabled == false
    error_message = "Push mirror should be disabled"
  }
}

run "multiple_push_mirrors" {
  command = plan

  variables {
    type = "push"

    target = {
      "100" = {
        url = "https://github.com/org/repo1.git"
      }
      "200" = {
        url = "https://github.com/org/repo2.git"
      }
      "300" = {
        url = "https://github.com/org/repo3.git"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_push_mirror.push_target) == 3
    error_message = "Should create 3 push mirrors"
  }
}

run "empty_target" {
  command = plan

  variables {
    type   = "push"
    target = {}
  }

  assert {
    condition     = length(gitlab_project_push_mirror.push_target) == 0
    error_message = "Should create 0 push mirrors when target is empty"
  }

  assert {
    condition     = length(gitlab_project_pull_mirror.pull_target) == 0
    error_message = "Should create 0 pull mirrors when target is empty"
  }
}

run "push_mirror_with_ssh_auth" {
  command = plan

  variables {
    type = "push"

    target = {
      "123" = {
        url         = "git@github.com:example/repo.git"
        auth_method = "ssh_public_key"
      }
    }
  }

  assert {
    condition     = gitlab_project_push_mirror.push_target["123"].auth_method == "ssh_public_key"
    error_message = "Push mirror auth_method should be 'ssh_public_key'"
  }
}

run "mirror_with_branch_regex" {
  command = plan

  variables {
    type = "push"

    target = {
      "123" = {
        url                 = "https://github.com/example/repo.git"
        mirror_branch_regex = "^(main|release/.*)$"
      }
    }
  }

  assert {
    condition     = gitlab_project_push_mirror.push_target["123"].mirror_branch_regex == "^(main|release/.*)$"
    error_message = "Push mirror mirror_branch_regex should match"
  }
}
