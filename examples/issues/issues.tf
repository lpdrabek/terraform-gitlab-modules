module "issues" {
  source = "../../modules/issues"

  project_id  = data.gitlab_project.main_project.id
  issues_file = "${path.module}/issues.yml"

  issues = {
    # First issue: defines labels and milestone with FULL details
    "Setup CI/CD pipeline" = {
      title       = "Setup CI/CD pipeline"
      description = "Configure GitLab CI/CD for automated testing and deployment"
      issue_type  = "issue"
      labels = {
        enhancement = {
          color       = "#5CB85C"
          description = "New feature or request"
        }
        infrastructure = {
          color       = "#7F8C8D"
          description = "Infrastructure related"
        }
        "v1-release" = {
          color       = "#0052CC"
          description = "Targeted for v1.0.0 release"
        }
      }
      milestone = {
        "v1.0.0" = {
          description = "Initial release"
          start_date  = "2025-01-01"
          due_date    = "2025-03-31"
        }
      }
    }

    # Second issue: REUSES labels and milestone by name only (empty maps)
    "Write documentation" = {
      title       = "Write documentation"
      description = "Create user guide and API documentation"
      issue_type  = "issue"
      labels = {
        enhancement  = {} # Reuse - picks up color/description from first issue
        "v1-release" = {} # Reuse - picks up color/description from first issue
      }
      milestone = {
        "v1.0.0" = {} # Reuse - picks up dates/description from first issue
      }
    }

    # Third issue: REUSES milestone, defines NEW label, REUSES another
    "Fix login bug" = {
      title        = "Fix login bug"
      description  = "Users cannot login with special characters in password"
      issue_type   = "issue"
      due_date     = "2025-02-15"
      confidential = false
      labels = {
        bug = {
          color       = "#FF0000"
          description = "Something isn't working"
        }
        "v1-release" = {} # Reuse
      }
      milestone = {
        "v1.0.0" = {} # Reuse
      }
    }

    # Fourth issue: different milestone, reuses a label
    "Plan v2 features" = {
      title       = "Plan v2 features"
      description = "Roadmap planning for version 2"
      issue_type  = "issue"
      labels = {
        enhancement = {} # Reuse
      }
      milestone = {
        "v2.0.0" = {
          description = "Major release with breaking changes"
          start_date  = "2025-07-01"
          due_date    = "2025-12-31"
        }
      }
    }

    # Fifth issue: no milestone, no labels
    "Production outage template" = {
      title       = "Production outage - service unavailable"
      description = "Template for production incidents"
      issue_type  = "incident"
    }

    # Sixth issue: confidential issue with weight
    "Security vulnerability" = {
      title        = "Security vulnerability in authentication"
      description  = "Details redacted - see confidential notes"
      issue_type   = "issue"
      confidential = true
      weight       = 8
      labels = {
        bug = {}
      }
      milestone = {
        "v1.0.0" = {}
      }
    }

    # Seventh issue: test_case type
    "Login flow test case" = {
      title       = "Test case: User login flow"
      description = "Verify user can login with valid credentials"
      issue_type  = "test_case"
    }

    # Eighth issue: discussion locked
    "Archived decision" = {
      title             = "Architecture decision record"
      description       = "Decision has been made - discussion closed"
      issue_type        = "issue"
      discussion_locked = true
    }

    # Ninth issue: with delete_on_destroy
    "Temporary task" = {
      title             = "Temporary investigation task"
      description       = "This issue will be deleted when terraform destroys"
      issue_type        = "issue"
      delete_on_destroy = true
    }
  }
}

# Test create_milestones = false (reference existing milestones)
# Uncomment after running the main module once to create milestones
# module "issues_existing_milestones" {
#   source = "../../modules/issues"
#
#   project_id        = data.gitlab_project.main_project.id
#   create_milestones = false  # Use existing milestones from GitLab
#
#   issues = {
#     "Issue with existing milestone" = {
#       title       = "References existing milestone"
#       description = "This issue uses a milestone that already exists"
#       issue_type  = "issue"
#       milestone = {
#         "v1.0.0" = {}  # Must exist in GitLab already
#       }
#     }
#   }
# }

output "issues" {
  description = "Created issues"
  value       = module.issues.issues
}

output "milestones" {
  description = "Created milestones"
  value       = module.issues.milestones
}
