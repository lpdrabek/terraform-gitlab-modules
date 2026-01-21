mock_provider "gitlab" {}

run "basic_milestone" {
  command = plan

  variables {
    project_id = "123"

    milestones = {
      "v1.0" = {}
    }
  }

  assert {
    condition     = length(gitlab_project_milestone.milestones) == 1
    error_message = "Should create 1 milestone"
  }

  assert {
    condition     = length(gitlab_project_milestone.create_only_milestones) == 0
    error_message = "Should create 0 create_only milestones"
  }

  assert {
    condition     = gitlab_project_milestone.milestones["v1.0"].project == "123"
    error_message = "Milestone should be for project 123"
  }

  assert {
    condition     = gitlab_project_milestone.milestones["v1.0"].title == "v1.0"
    error_message = "Milestone title should be 'v1.0'"
  }
}

run "milestone_with_description" {
  command = plan

  variables {
    project_id = "123"

    milestones = {
      "Sprint 1" = {
        description = "First sprint milestone"
      }
    }
  }

  assert {
    condition     = gitlab_project_milestone.milestones["Sprint 1"].title == "Sprint 1"
    error_message = "Milestone title should be 'Sprint 1'"
  }

  assert {
    condition     = gitlab_project_milestone.milestones["Sprint 1"].description == "First sprint milestone"
    error_message = "Milestone description should match"
  }
}

run "milestone_with_dates" {
  command = plan

  variables {
    project_id = "123"

    milestones = {
      "Q1 2026" = {
        start_date = "2026-01-01"
        due_date   = "2026-03-31"
      }
    }
  }

  assert {
    condition     = gitlab_project_milestone.milestones["Q1 2026"].start_date == "2026-01-01"
    error_message = "Milestone start_date should be '2026-01-01'"
  }

  assert {
    condition     = gitlab_project_milestone.milestones["Q1 2026"].due_date == "2026-03-31"
    error_message = "Milestone due_date should be '2026-03-31'"
  }
}

run "milestone_with_state" {
  command = plan

  variables {
    project_id = "123"

    milestones = {
      "active-milestone" = {
        state = "active"
      }
      "closed-milestone" = {
        state = "closed"
      }
    }
  }

  assert {
    condition     = gitlab_project_milestone.milestones["active-milestone"].state == "active"
    error_message = "active-milestone state should be 'active'"
  }

  assert {
    condition     = gitlab_project_milestone.milestones["closed-milestone"].state == "closed"
    error_message = "closed-milestone state should be 'closed'"
  }
}

run "milestone_complete" {
  command = plan

  variables {
    project_id = "456"

    milestones = {
      "Release 2.0" = {
        description = "Major release milestone"
        state       = "active"
        start_date  = "2026-06-01"
        due_date    = "2026-06-30"
      }
    }
  }

  assert {
    condition     = gitlab_project_milestone.milestones["Release 2.0"].project == "456"
    error_message = "Milestone should be for project 456"
  }

  assert {
    condition     = gitlab_project_milestone.milestones["Release 2.0"].title == "Release 2.0"
    error_message = "Milestone title should be 'Release 2.0'"
  }

  assert {
    condition     = gitlab_project_milestone.milestones["Release 2.0"].description == "Major release milestone"
    error_message = "Milestone description should match"
  }

  assert {
    condition     = gitlab_project_milestone.milestones["Release 2.0"].state == "active"
    error_message = "Milestone state should be 'active'"
  }

  assert {
    condition     = gitlab_project_milestone.milestones["Release 2.0"].start_date == "2026-06-01"
    error_message = "Milestone start_date should match"
  }

  assert {
    condition     = gitlab_project_milestone.milestones["Release 2.0"].due_date == "2026-06-30"
    error_message = "Milestone due_date should match"
  }
}

run "multiple_milestones" {
  command = plan

  variables {
    project_id = "123"

    milestones = {
      "v1.0" = {
        description = "Version 1.0"
      }
      "v1.1" = {
        description = "Version 1.1"
      }
      "v2.0" = {
        description = "Version 2.0"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_milestone.milestones) == 3
    error_message = "Should create 3 milestones"
  }

  assert {
    condition     = gitlab_project_milestone.milestones["v1.0"].description == "Version 1.0"
    error_message = "v1.0 description should match"
  }

  assert {
    condition     = gitlab_project_milestone.milestones["v1.1"].description == "Version 1.1"
    error_message = "v1.1 description should match"
  }

  assert {
    condition     = gitlab_project_milestone.milestones["v2.0"].description == "Version 2.0"
    error_message = "v2.0 description should match"
  }
}

run "create_only_milestone" {
  command = plan

  variables {
    project_id  = "123"
    create_only = true

    milestones = {
      "create-only-milestone" = {
        description = "A create-only milestone"
        state       = "active"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_milestone.milestones) == 0
    error_message = "Should create 0 normal milestones"
  }

  assert {
    condition     = length(gitlab_project_milestone.create_only_milestones) == 1
    error_message = "Should create 1 create_only milestone"
  }

  assert {
    condition     = gitlab_project_milestone.create_only_milestones["create-only-milestone"].title == "create-only-milestone"
    error_message = "create_only milestone title should match"
  }

  assert {
    condition     = gitlab_project_milestone.create_only_milestones["create-only-milestone"].description == "A create-only milestone"
    error_message = "create_only milestone description should match"
  }
}

run "empty_milestones" {
  command = plan

  variables {
    project_id = "123"
    milestones = {}
  }

  assert {
    condition     = length(gitlab_project_milestone.milestones) == 0
    error_message = "Should create 0 milestones when milestones is empty"
  }

  assert {
    condition     = length(gitlab_project_milestone.create_only_milestones) == 0
    error_message = "Should create 0 create_only milestones when milestones is empty"
  }
}
