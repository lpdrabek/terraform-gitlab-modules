mock_provider "gitlab" {}
mock_provider "random" {}

run "basic_issue" {
  command = plan

  variables {
    project_id = "123"

    issues = {
      "my-issue" = {
        title = "My First Issue"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_issue.issues) == 1
    error_message = "Should create 1 issue"
  }

  assert {
    condition     = length(gitlab_project_issue.create_only_issues) == 0
    error_message = "Should create 0 create_only issues"
  }

  assert {
    condition     = gitlab_project_issue.issues["my-issue"].project == "123"
    error_message = "Issue should be for project 123"
  }

  assert {
    condition     = gitlab_project_issue.issues["my-issue"].title == "My First Issue"
    error_message = "Issue title should be 'My First Issue'"
  }
}

run "issue_with_description" {
  command = plan

  variables {
    project_id = "123"

    issues = {
      "detailed-issue" = {
        title       = "Detailed Issue"
        description = "This is a detailed description of the issue."
      }
    }
  }

  assert {
    condition     = gitlab_project_issue.issues["detailed-issue"].title == "Detailed Issue"
    error_message = "Issue title should match"
  }

  assert {
    condition     = gitlab_project_issue.issues["detailed-issue"].description == "This is a detailed description of the issue."
    error_message = "Issue description should match"
  }
}

run "issue_with_type_and_state" {
  command = plan

  variables {
    project_id = "123"

    issues = {
      "incident" = {
        title      = "Production Incident"
        issue_type = "incident"
        state      = "opened"
      }
    }
  }

  assert {
    condition     = gitlab_project_issue.issues["incident"].issue_type == "incident"
    error_message = "Issue type should be 'incident'"
  }

  assert {
    condition     = gitlab_project_issue.issues["incident"].state == "opened"
    error_message = "Issue state should be 'opened'"
  }
}

run "issue_with_due_date" {
  command = plan

  variables {
    project_id = "123"

    issues = {
      "scheduled-issue" = {
        title    = "Scheduled Task"
        due_date = "2026-12-31"
      }
    }
  }

  assert {
    condition     = gitlab_project_issue.issues["scheduled-issue"].due_date == "2026-12-31"
    error_message = "Issue due_date should be '2026-12-31'"
  }
}

run "issue_with_weight" {
  command = plan

  variables {
    project_id = "123"

    issues = {
      "weighted-issue" = {
        title  = "Weighted Issue"
        weight = 5
      }
    }
  }

  assert {
    condition     = gitlab_project_issue.issues["weighted-issue"].weight == 5
    error_message = "Issue weight should be 5"
  }
}

run "issue_confidential" {
  command = plan

  variables {
    project_id = "123"

    issues = {
      "secret-issue" = {
        title        = "Confidential Issue"
        confidential = true
      }
    }
  }

  assert {
    condition     = gitlab_project_issue.issues["secret-issue"].confidential == true
    error_message = "Issue should be confidential"
  }
}

run "multiple_issues" {
  command = plan

  variables {
    project_id = "123"

    issues = {
      "issue-1" = {
        title = "First Issue"
      }
      "issue-2" = {
        title = "Second Issue"
      }
      "issue-3" = {
        title = "Third Issue"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_issue.issues) == 3
    error_message = "Should create 3 issues"
  }

  assert {
    condition     = gitlab_project_issue.issues["issue-1"].title == "First Issue"
    error_message = "First issue title should match"
  }

  assert {
    condition     = gitlab_project_issue.issues["issue-2"].title == "Second Issue"
    error_message = "Second issue title should match"
  }

  assert {
    condition     = gitlab_project_issue.issues["issue-3"].title == "Third Issue"
    error_message = "Third issue title should match"
  }
}

run "create_only_issue" {
  command = plan

  variables {
    project_id  = "123"
    create_only = true

    issues = {
      "create-only-issue" = {
        title       = "Create Only Issue"
        description = "This issue uses create_only mode"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_issue.issues) == 0
    error_message = "Should create 0 normal issues"
  }

  assert {
    condition     = length(gitlab_project_issue.create_only_issues) == 1
    error_message = "Should create 1 create_only issue"
  }

  assert {
    condition     = gitlab_project_issue.create_only_issues["create-only-issue"].title == "Create Only Issue"
    error_message = "create_only issue title should match"
  }
}

run "issue_types" {
  command = plan

  variables {
    project_id = "123"

    issues = {
      "regular-issue" = {
        title      = "Regular Issue"
        issue_type = "issue"
      }
      "incident-issue" = {
        title      = "Incident"
        issue_type = "incident"
      }
      "test-case-issue" = {
        title      = "Test Case"
        issue_type = "test_case"
      }
    }
  }

  assert {
    condition     = gitlab_project_issue.issues["regular-issue"].issue_type == "issue"
    error_message = "regular-issue type should be 'issue'"
  }

  assert {
    condition     = gitlab_project_issue.issues["incident-issue"].issue_type == "incident"
    error_message = "incident-issue type should be 'incident'"
  }

  assert {
    condition     = gitlab_project_issue.issues["test-case-issue"].issue_type == "test_case"
    error_message = "test-case-issue type should be 'test_case'"
  }
}

run "empty_issues" {
  command = plan

  variables {
    project_id = "123"
    issues     = {}
  }

  assert {
    condition     = length(gitlab_project_issue.issues) == 0
    error_message = "Should create 0 issues when issues is empty"
  }

  assert {
    condition     = length(gitlab_project_issue.create_only_issues) == 0
    error_message = "Should create 0 create_only issues when issues is empty"
  }
}

run "closed_issue" {
  command = plan

  variables {
    project_id = "123"

    issues = {
      "closed-issue" = {
        title = "Closed Issue"
        state = "closed"
      }
    }
  }

  assert {
    condition     = gitlab_project_issue.issues["closed-issue"].state == "closed"
    error_message = "Issue state should be 'closed'"
  }
}
