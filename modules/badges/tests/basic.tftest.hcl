mock_provider "gitlab" {}

run "project_badge" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    badges = {
      "cicd-badge" = {
        link_url  = "https://example.com"
        image_url = "https://example.com/image.png"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_badge.badges) == 1
    error_message = "Should create 1 project badge"
  }
  assert {
    condition     = length(gitlab_group_badge.badges) == 0
    error_message = "Should create 0 group badges"
  }
  assert {
    condition     = length(gitlab_project_badge.create_only_badges) == 0
    error_message = "Should create 0 create_only project badges"
  }
  assert {
    condition     = length(gitlab_group_badge.create_only_badges) == 0
    error_message = "Should create 0 create_only group badges"
  }

  assert {
    condition     = gitlab_project_badge.badges["cicd-badge"].name == "cicd-badge"
    error_message = "Should be named \"cicd-badge\""
  }
  assert {
    condition     = gitlab_project_badge.badges["cicd-badge"].link_url == "https://example.com"
    error_message = "link_url should be \"https://example.com\""
  }
  assert {
    condition     = gitlab_project_badge.badges["cicd-badge"].image_url == "https://example.com/image.png"
    error_message = "image_url should be \"https://example.com/image.png\""
  }
  assert {
    condition     = gitlab_project_badge.badges["cicd-badge"].project == "123"
    error_message = "badge should be in project 123"
  }
}

run "group_badge" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "456"
    }

    badges = {
      "group-badge" = {
        link_url  = "https://example.com"
        image_url = "https://example.com/image.png"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_badge.badges) == 0
    error_message = "Should create 0 project badge"
  }
  assert {
    condition     = length(gitlab_group_badge.badges) == 1
    error_message = "Should create 1 group badges"
  }
  assert {
    condition     = length(gitlab_project_badge.create_only_badges) == 0
    error_message = "Should create 0 create_only project badges"
  }
  assert {
    condition     = length(gitlab_group_badge.create_only_badges) == 0
    error_message = "Should create 0 create_only group badges"
  }

  assert {
    condition     = gitlab_group_badge.badges["group-badge"].name == "group-badge"
    error_message = "Should be named \"group-badge\""
  }
  assert {
    condition     = gitlab_group_badge.badges["group-badge"].link_url == "https://example.com"
    error_message = "link_url should be \"https://example.com\""
  }
  assert {
    condition     = gitlab_group_badge.badges["group-badge"].image_url == "https://example.com/image.png"
    error_message = "image_url should be \"https://example.com/image.png\""
  }
}

run "create_only_project_badge" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    create_only = true
    badges = {
      "cicd-badge" = {
        link_url  = "https://example.com"
        image_url = "https://example.com/image.png"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_badge.badges) == 0
    error_message = "Should create 0 project badge"
  }
  assert {
    condition     = length(gitlab_group_badge.badges) == 0
    error_message = "Should create 0 group badges"
  }
  assert {
    condition     = length(gitlab_project_badge.create_only_badges) == 1
    error_message = "Should create 1 create_only project badges"
  }
  assert {
    condition     = length(gitlab_group_badge.create_only_badges) == 0
    error_message = "Should create 0 create_only group badges"
  }

  assert {
    condition     = gitlab_project_badge.create_only_badges["cicd-badge"].name == "cicd-badge"
    error_message = "Should be named \"cicd-badge\""
  }
  assert {
    condition     = gitlab_project_badge.create_only_badges["cicd-badge"].link_url == "https://example.com"
    error_message = "link_url should be \"https://example.com\""
  }
  assert {
    condition     = gitlab_project_badge.create_only_badges["cicd-badge"].image_url == "https://example.com/image.png"
    error_message = "image_url should be \"https://example.com/image.png\""
  }
  assert {
    condition     = gitlab_project_badge.create_only_badges["cicd-badge"].project == "123"
    error_message = "badge should be in project 123"
  }
}

run "create_only_group_badge" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "456"
    }

    create_only = true
    badges = {
      "group-badge" = {
        link_url  = "https://example.com"
        image_url = "https://example.com/image.png"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_badge.badges) == 0
    error_message = "Should create 0 project badge"
  }
  assert {
    condition     = length(gitlab_group_badge.badges) == 0
    error_message = "Should create 0 group badges"
  }
  assert {
    condition     = length(gitlab_project_badge.create_only_badges) == 0
    error_message = "Should create 0 create_only project badges"
  }
  assert {
    condition     = length(gitlab_group_badge.create_only_badges) == 1
    error_message = "Should create 1 create_only group badges"
  }

  assert {
    condition     = gitlab_group_badge.create_only_badges["group-badge"].name == "group-badge"
    error_message = "Should be named \"group-badge\""
  }
  assert {
    condition     = gitlab_group_badge.create_only_badges["group-badge"].link_url == "https://example.com"
    error_message = "link_url should be \"https://example.com\""
  }
  assert {
    condition     = gitlab_group_badge.create_only_badges["group-badge"].image_url == "https://example.com/image.png"
    error_message = "image_url should be \"https://example.com/image.png\""
  }
}
