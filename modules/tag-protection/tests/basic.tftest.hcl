mock_provider "gitlab" {}

run "basic_tag_protection" {
  command = plan

  variables {
    project = "123"

    tags = {
      "v*" = {}
    }
  }

  assert {
    condition     = length(gitlab_tag_protection.tags) == 1
    error_message = "Should create 1 tag protection"
  }

  assert {
    condition     = length(gitlab_tag_protection.create_only_tags) == 0
    error_message = "Should create 0 create_only tag protections"
  }

  assert {
    condition     = gitlab_tag_protection.tags["v*"].project == "123"
    error_message = "Tag protection should be for project 123"
  }

  assert {
    condition     = gitlab_tag_protection.tags["v*"].tag == "v*"
    error_message = "Tag pattern should be 'v*'"
  }
}

run "tag_protection_with_access_level" {
  command = plan

  variables {
    project = "456"

    tags = {
      "release-*" = {
        create_access_level = "maintainer"
      }
    }
  }

  assert {
    condition     = gitlab_tag_protection.tags["release-*"].create_access_level == "maintainer"
    error_message = "create_access_level should be 'maintainer'"
  }

  assert {
    condition     = gitlab_tag_protection.tags["release-*"].tag == "release-*"
    error_message = "Tag pattern should be 'release-*'"
  }
}

run "tag_protection_no_one" {
  command = plan

  variables {
    project = "789"

    tags = {
      "protected-*" = {
        create_access_level = "no one"
      }
    }
  }

  assert {
    condition     = gitlab_tag_protection.tags["protected-*"].create_access_level == "no one"
    error_message = "create_access_level should be 'no one'"
  }
}

run "tag_protection_developer" {
  command = plan

  variables {
    project = "123"

    tags = {
      "dev-*" = {
        create_access_level = "developer"
      }
    }
  }

  assert {
    condition     = gitlab_tag_protection.tags["dev-*"].create_access_level == "developer"
    error_message = "create_access_level should be 'developer'"
  }
}

run "multiple_tag_protections" {
  command = plan

  variables {
    project = "123"

    tags = {
      "v*" = {
        create_access_level = "maintainer"
      }
      "release-*" = {
        create_access_level = "maintainer"
      }
      "hotfix-*" = {
        create_access_level = "developer"
      }
    }
  }

  assert {
    condition     = length(gitlab_tag_protection.tags) == 3
    error_message = "Should create 3 tag protections"
  }

  assert {
    condition     = gitlab_tag_protection.tags["v*"].create_access_level == "maintainer"
    error_message = "v* tag protection access level should be 'maintainer'"
  }

  assert {
    condition     = gitlab_tag_protection.tags["release-*"].create_access_level == "maintainer"
    error_message = "release-* tag protection access level should be 'maintainer'"
  }

  assert {
    condition     = gitlab_tag_protection.tags["hotfix-*"].create_access_level == "developer"
    error_message = "hotfix-* tag protection access level should be 'developer'"
  }
}

run "create_only_tag_protection" {
  command = plan

  variables {
    project     = "123"
    create_only = true

    tags = {
      "v*" = {
        create_access_level = "maintainer"
      }
    }
  }

  assert {
    condition     = length(gitlab_tag_protection.tags) == 0
    error_message = "Should create 0 normal tag protections"
  }

  assert {
    condition     = length(gitlab_tag_protection.create_only_tags) == 1
    error_message = "Should create 1 create_only tag protection"
  }

  assert {
    condition     = gitlab_tag_protection.create_only_tags["v*"].project == "123"
    error_message = "create_only tag protection should be for project 123"
  }

  assert {
    condition     = gitlab_tag_protection.create_only_tags["v*"].tag == "v*"
    error_message = "create_only tag pattern should be 'v*'"
  }

  assert {
    condition     = gitlab_tag_protection.create_only_tags["v*"].create_access_level == "maintainer"
    error_message = "create_only tag protection access level should be 'maintainer'"
  }
}

run "empty_tags" {
  command = plan

  variables {
    project = "123"
    tags    = {}
  }

  assert {
    condition     = length(gitlab_tag_protection.tags) == 0
    error_message = "Should create 0 tag protections when tags is empty"
  }

  assert {
    condition     = length(gitlab_tag_protection.create_only_tags) == 0
    error_message = "Should create 0 create_only tag protections when tags is empty"
  }
}

run "exact_tag_protection" {
  command = plan

  variables {
    project = "123"

    tags = {
      "v1.0.0" = {
        create_access_level = "no one"
      }
    }
  }

  assert {
    condition     = gitlab_tag_protection.tags["v1.0.0"].tag == "v1.0.0"
    error_message = "Exact tag 'v1.0.0' should be protected"
  }

  assert {
    condition     = gitlab_tag_protection.tags["v1.0.0"].create_access_level == "no one"
    error_message = "Exact tag protection should have 'no one' access level"
  }
}
