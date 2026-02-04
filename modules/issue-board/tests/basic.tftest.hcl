mock_provider "gitlab" {}

run "project_issue_board_basic" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    boards = {
      "Development Board" = {}
    }
  }

  assert {
    condition     = length(gitlab_project_issue_board.issue_board) == 1
    error_message = "Should create 1 project issue board"
  }

  assert {
    condition     = length(gitlab_group_issue_board.issue_board) == 0
    error_message = "Should create 0 group issue boards"
  }

  assert {
    condition     = gitlab_project_issue_board.issue_board["Development Board"].name == "Development Board"
    error_message = "Board name should be 'Development Board'"
  }

  assert {
    condition     = gitlab_project_issue_board.issue_board["Development Board"].project == "123"
    error_message = "Board should be for project 123"
  }
}

run "group_issue_board_basic" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "456"
    }

    boards = {
      "Group Board" = {}
    }
  }

  assert {
    condition     = length(gitlab_project_issue_board.issue_board) == 0
    error_message = "Should create 0 project issue boards"
  }

  assert {
    condition     = length(gitlab_group_issue_board.issue_board) == 1
    error_message = "Should create 1 group issue board"
  }

  assert {
    condition     = gitlab_group_issue_board.issue_board["Group Board"].name == "Group Board"
    error_message = "Board name should be 'Group Board'"
  }

  assert {
    condition     = gitlab_group_issue_board.issue_board["Group Board"].group == "456"
    error_message = "Board should be for group 456"
  }
}

run "project_issue_board_with_labels" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    boards = {
      "Sprint Board" = {
        labels = ["bug", "feature", "enhancement"]
      }
    }
  }

  assert {
    condition     = length(gitlab_project_issue_board.issue_board) == 1
    error_message = "Should create 1 project issue board"
  }

  assert {
    condition     = contains(gitlab_project_issue_board.issue_board["Sprint Board"].labels, "bug")
    error_message = "Board should have 'bug' label"
  }

  assert {
    condition     = contains(gitlab_project_issue_board.issue_board["Sprint Board"].labels, "feature")
    error_message = "Board should have 'feature' label"
  }

  assert {
    condition     = contains(gitlab_project_issue_board.issue_board["Sprint Board"].labels, "enhancement")
    error_message = "Board should have 'enhancement' label"
  }
}

run "project_issue_board_with_filters" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    boards = {
      "Filtered Board" = {
        assignee_id  = 42
        milestone_id = 10
        weight       = 5
      }
    }
  }

  assert {
    condition     = gitlab_project_issue_board.issue_board["Filtered Board"].assignee_id == 42
    error_message = "Board should have assignee_id 42"
  }

  assert {
    condition     = gitlab_project_issue_board.issue_board["Filtered Board"].milestone_id == 10
    error_message = "Board should have milestone_id 10"
  }

  assert {
    condition     = gitlab_project_issue_board.issue_board["Filtered Board"].weight == 5
    error_message = "Board should have weight 5"
  }
}

run "multiple_project_boards" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    boards = {
      "Board 1" = {
        labels = ["priority::high"]
      }
      "Board 2" = {
        labels = ["priority::low"]
      }
      "Board 3" = {}
    }
  }

  assert {
    condition     = length(gitlab_project_issue_board.issue_board) == 3
    error_message = "Should create 3 project issue boards"
  }
}

run "group_issue_board_with_milestone" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "789"
    }

    boards = {
      "Milestone Board" = {
        milestone_id = 25
        labels       = ["team::backend"]
      }
    }
  }

  assert {
    condition     = gitlab_group_issue_board.issue_board["Milestone Board"].milestone_id == 25
    error_message = "Board should have milestone_id 25"
  }

  assert {
    condition     = contains(gitlab_group_issue_board.issue_board["Milestone Board"].labels, "team::backend")
    error_message = "Board should have 'team::backend' label"
  }
}

run "empty_boards" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    boards = {}
  }

  assert {
    condition     = length(gitlab_project_issue_board.issue_board) == 0
    error_message = "Should create 0 project issue boards when boards is empty"
  }

  assert {
    condition     = length(gitlab_group_issue_board.issue_board) == 0
    error_message = "Should create 0 group issue boards when boards is empty"
  }
}
