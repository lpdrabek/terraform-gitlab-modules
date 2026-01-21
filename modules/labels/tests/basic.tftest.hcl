mock_provider "gitlab" {}
mock_provider "random" {}

run "project_label_basic" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    labels = {
      "bug" = {
        color       = "#FF0000"
        description = "Bug label"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_label.project_labels) == 1
    error_message = "Should create 1 project label"
  }

  assert {
    condition     = length(gitlab_group_label.group_labels) == 0
    error_message = "Should create 0 group labels"
  }

  assert {
    condition     = length(gitlab_project_label.create_only_project_labels) == 0
    error_message = "Should create 0 create_only project labels"
  }

  assert {
    condition     = length(gitlab_group_label.create_only_group_labels) == 0
    error_message = "Should create 0 create_only group labels"
  }

  assert {
    condition     = gitlab_project_label.project_labels["bug"].name == "bug"
    error_message = "Label name should be 'bug'"
  }

  assert {
    condition     = gitlab_project_label.project_labels["bug"].project == "123"
    error_message = "Label should be for project 123"
  }

  assert {
    condition     = gitlab_project_label.project_labels["bug"].color == "#FF0000"
    error_message = "Label color should be '#FF0000'"
  }

  assert {
    condition     = gitlab_project_label.project_labels["bug"].description == "Bug label"
    error_message = "Label description should be 'Bug label'"
  }
}

run "group_label_basic" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "456"
    }

    labels = {
      "feature" = {
        color       = "#00FF00"
        description = "Feature label"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_label.project_labels) == 0
    error_message = "Should create 0 project labels"
  }

  assert {
    condition     = length(gitlab_group_label.group_labels) == 1
    error_message = "Should create 1 group label"
  }

  assert {
    condition     = gitlab_group_label.group_labels["feature"].name == "feature"
    error_message = "Label name should be 'feature'"
  }

  assert {
    condition     = gitlab_group_label.group_labels["feature"].group == "456"
    error_message = "Label should be for group 456"
  }

  assert {
    condition     = gitlab_group_label.group_labels["feature"].color == "#00FF00"
    error_message = "Label color should be '#00FF00'"
  }
}

run "project_label_auto_color" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    labels = {
      "auto-color-label" = {
        description = "Label with auto-generated color"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_label.project_labels) == 1
    error_message = "Should create 1 project label"
  }

  assert {
    condition     = length(random_id.label_color) == 1
    error_message = "Should create 1 random color"
  }
}

run "multiple_project_labels" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    labels = {
      "bug" = {
        color       = "#FF0000"
        description = "Bug label"
      }
      "feature" = {
        color       = "#00FF00"
        description = "Feature label"
      }
      "enhancement" = {
        color       = "#0000FF"
        description = "Enhancement label"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_label.project_labels) == 3
    error_message = "Should create 3 project labels"
  }

  assert {
    condition     = gitlab_project_label.project_labels["bug"].color == "#FF0000"
    error_message = "bug label color should be '#FF0000'"
  }

  assert {
    condition     = gitlab_project_label.project_labels["feature"].color == "#00FF00"
    error_message = "feature label color should be '#00FF00'"
  }

  assert {
    condition     = gitlab_project_label.project_labels["enhancement"].color == "#0000FF"
    error_message = "enhancement label color should be '#0000FF'"
  }
}

run "create_only_project_label" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    create_only = true

    labels = {
      "create-only-label" = {
        color       = "#FFFF00"
        description = "Create only label"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_label.project_labels) == 0
    error_message = "Should create 0 normal project labels"
  }

  assert {
    condition     = length(gitlab_project_label.create_only_project_labels) == 1
    error_message = "Should create 1 create_only project label"
  }

  assert {
    condition     = gitlab_project_label.create_only_project_labels["create-only-label"].name == "create-only-label"
    error_message = "create_only label name should match"
  }

  assert {
    condition     = gitlab_project_label.create_only_project_labels["create-only-label"].color == "#FFFF00"
    error_message = "create_only label color should be '#FFFF00'"
  }
}

run "create_only_group_label" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "456"
    }

    create_only = true

    labels = {
      "group-create-only" = {
        color       = "#FF00FF"
        description = "Group create only label"
      }
    }
  }

  assert {
    condition     = length(gitlab_group_label.group_labels) == 0
    error_message = "Should create 0 normal group labels"
  }

  assert {
    condition     = length(gitlab_group_label.create_only_group_labels) == 1
    error_message = "Should create 1 create_only group label"
  }

  assert {
    condition     = gitlab_group_label.create_only_group_labels["group-create-only"].name == "group-create-only"
    error_message = "create_only group label name should match"
  }
}

run "empty_labels" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    labels = {}
  }

  assert {
    condition     = length(gitlab_project_label.project_labels) == 0
    error_message = "Should create 0 project labels when labels is empty"
  }

  assert {
    condition     = length(gitlab_group_label.group_labels) == 0
    error_message = "Should create 0 group labels when labels is empty"
  }

  assert {
    condition     = length(gitlab_project_label.create_only_project_labels) == 0
    error_message = "Should create 0 create_only project labels when labels is empty"
  }

  assert {
    condition     = length(gitlab_group_label.create_only_group_labels) == 0
    error_message = "Should create 0 create_only group labels when labels is empty"
  }
}

run "label_with_only_description" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    labels = {
      "descriptive-label" = {
        description = "A label with only a description"
      }
    }
  }

  assert {
    condition     = gitlab_project_label.project_labels["descriptive-label"].description == "A label with only a description"
    error_message = "Label should have the correct description"
  }
}
