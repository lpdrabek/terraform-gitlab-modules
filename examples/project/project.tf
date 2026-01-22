# =============================================================================
# Project Module Example
# Tests creating multiple GitLab projects with various configurations
# =============================================================================

module "projects" {
  source = "../../modules/project"

  projects = {
    # -----------------------------------------------------------------------------
    # Basic Project - minimal configuration
    # -----------------------------------------------------------------------------
    "tf-test-basic" = {
      description            = "Basic test project with minimal config"
      namespace_id           = data.gitlab_group.main_group.id
      initialize_with_readme = true
    }

    # -----------------------------------------------------------------------------
    # Full-Featured Project - comprehensive settings
    # -----------------------------------------------------------------------------
    "tf-test-full" = {
      description      = "Full-featured test project"
      namespace_id     = data.gitlab_group.main_group.id
      visibility_level = "private"

      # Initialize with README
      initialize_with_readme = true

      # Topics/Tags
      topics = ["terraform", "testing", "gitlab"]

      # CI/CD Settings
      ci_config_path                = ".gitlab-ci.yml"
      ci_default_git_depth          = 50
      build_timeout                 = 7200
      build_git_strategy            = "fetch"
      auto_cancel_pending_pipelines = "enabled"
      ci_separated_caches           = true
      public_jobs                   = false
      shared_runners_enabled        = true
      group_runners_enabled         = true
      keep_latest_artifact          = true

      # Merge Request Settings
      only_allow_merge_if_pipeline_succeeds            = true
      only_allow_merge_if_all_discussions_are_resolved = true
      merge_method                                     = "merge"
      squash_option                                    = "default_on"
      remove_source_branch_after_merge                 = true
      resolve_outdated_diff_discussions                = true
      printing_merge_request_link_enabled              = true

      # Access Levels
      issues_access_level         = "enabled"
      merge_requests_access_level = "enabled"
      wiki_access_level           = "enabled"
      builds_access_level         = "enabled"
      snippets_access_level       = "enabled"
      pages_access_level          = "private"

      # Security
      lfs_enabled = true

      # Additional Features
      request_access_enabled      = true
      emails_enabled              = true
      autoclose_referenced_issues = true

      # Inline Milestones
      milestones = {
        "v1.0" = {
          description = "First major release"
          due_date    = "2026-06-01"
        }
        "v1.1" = {
          description = "Minor improvements"
          start_date  = "2026-06-02"
          due_date    = "2026-09-01"
        }
      }

      # Inline Labels
      labels = {
        "bug" = {
          color       = "#FF0000"
          description = "Something isn't working"
        }
        "enhancement" = {
          color       = "#0052CC"
          description = "New feature or request"
        }
        "documentation" = {
          color       = "#0E8A16"
          description = "Improvements or additions to documentation"
        }
        "priority::high" = {
          color       = "#D93F0B"
          description = "High priority issue"
        }
        "priority::low" = {
          color       = "#C2E0C6"
          description = "Low priority issue"
        }
      }

      # Inline Badges
      badges = {
        "pipeline" = {
          link_url  = "https://gitlab.com/%%{project_path}/-/pipelines"
          image_url = "https://gitlab.com/%%{project_path}/badges/%%{default_branch}/pipeline.svg"
        }
        "coverage" = {
          link_url  = "https://gitlab.com/%%{project_path}/-/commits/%%{default_branch}"
          image_url = "https://gitlab.com/%%{project_path}/badges/%%{default_branch}/coverage.svg"
        }
      }

      # Inline Issues
      issues = {
        "setup-ci" = {
          title       = "Set up CI/CD pipeline"
          description = "Configure the GitLab CI/CD pipeline for automated testing and deployment."
          labels = {
            "enhancement"    = {}
            "priority::high" = {}
          }
          milestone = {
            "v1.0" = {}
          }
        }
        "add-readme" = {
          title       = "Create comprehensive README"
          description = "Add detailed README with installation instructions, usage examples, and contribution guidelines."
          labels = {
            "documentation" = {}
          }
        }
      }
    }

    # -----------------------------------------------------------------------------
    # Project with Push Rules (requires Premium/Ultimate)
    # -----------------------------------------------------------------------------
    # "tf-test-push-rules" = {
    #   description              = "Project with push rules"
    #   namespace_id             = data.gitlab_group.main_group.id
    #   initialize_with_readme   = true

    #   push_rules = {
    #     commit_message_regex = "^(feat|fix|docs|style|refactor|test|chore):"
    #     branch_name_regex    = "^(main|develop|feature/|bugfix/|hotfix/|release/).*"
    #     prevent_secrets      = true
    #     max_file_size        = 100
    #   }
    # }

    # -----------------------------------------------------------------------------
    # Project with Container Expiration Policy
    # -----------------------------------------------------------------------------
    "tf-test-container-policy" = {
      description            = "Project with container registry cleanup"
      namespace_id           = data.gitlab_group.main_group.id
      initialize_with_readme = true

      container_registry_access_level = "enabled"

      container_expiration_policy = {
        enabled           = true
        cadence           = "1month"
        keep_n            = 10
        older_than        = "90d"
        name_regex_delete = ".*"
        name_regex_keep   = "^(main|master|latest)$"
      }
    }

    # -----------------------------------------------------------------------------
    # Archived Project
    # -----------------------------------------------------------------------------
    "tf-test-archived" = {
      description            = "An archived legacy project"
      namespace_id           = data.gitlab_group.main_group.id
      initialize_with_readme = true
      archived               = true
      archive_on_destroy     = true
    }

    # -----------------------------------------------------------------------------
    # Project with Mixed create_only Settings
    # Labels and badges are fully managed, milestones and issues are create_only
    # -----------------------------------------------------------------------------
    "tf-test-mixed-create-only" = {
      description            = "Project with mixed create_only settings"
      namespace_id           = data.gitlab_group.main_group.id
      initialize_with_readme = true

      # Labels - fully managed (changes will be synced)
      labels = {
        "priority::p1" = {
          color       = "#FF0000"
          description = "Critical priority"
        }
        "priority::p2" = {
          color       = "#FFA500"
          description = "High priority"
        }
      }
      labels_create_only = false # default, labels changes are tracked

      # Badges - fully managed (changes will be synced)
      badges = {
        "status" = {
          link_url  = "https://gitlab.com/%%{project_path}"
          image_url = "https://img.shields.io/badge/status-active-green.svg"
        }
      }
      badges_create_only = false # default, badge changes are tracked

      # Milestones - create only (manual edits in UI preserved)
      milestones = {
        "Phase 1" = {
          description = "Initial phase"
          due_date    = "2026-03-01"
        }
        "Phase 2" = {
          description = "Secondary phase"
          due_date    = "2026-06-01"
        }
      }
      milestones_create_only = true # milestones won't be updated after creation

      # Issues - create only (manual edits in UI preserved)
      issues = {
        "kickoff" = {
          title       = "Project Kickoff"
          description = "Initial project planning and setup"
          labels = {
            "priority::p1" = {}
          }
          milestone = {
            "Phase 1" = {}
          }
        }
      }
      issues_create_only = true # issues won't be updated after creation
    }

    # -----------------------------------------------------------------------------
    # Project with All Resources as create_only
    # Everything is created but not managed after initial creation
    # -----------------------------------------------------------------------------
    "tf-test-all-create-only" = {
      description            = "Project where all resources use create_only"
      namespace_id           = data.gitlab_group.main_group.id
      initialize_with_readme = true

      labels = {
        "area::frontend" = {
          color       = "#428BCA"
          description = "Frontend related"
        }
        "area::backend" = {
          color       = "#5CB85C"
          description = "Backend related"
        }
      }
      labels_create_only = true

      badges = {
        "docs" = {
          link_url  = "https://example.com/docs"
          image_url = "https://img.shields.io/badge/docs-available-blue.svg"
        }
      }
      badges_create_only = true

      milestones = {
        "MVP" = {
          description = "Minimum viable product"
          due_date    = "2026-04-01"
        }
      }
      milestones_create_only = true

      issues = {
        "initial-setup" = {
          title       = "Initial Setup"
          description = "Set up the project infrastructure"
        }
      }
      issues_create_only = true
    }

    # -----------------------------------------------------------------------------
    # Project with Strict MR Settings
    # -----------------------------------------------------------------------------
    "tf-test-strict-mr" = {
      description            = "Project with strict MR requirements"
      namespace_id           = data.gitlab_group.main_group.id
      initialize_with_readme = true

      # Strict merge requirements
      only_allow_merge_if_pipeline_succeeds            = true
      only_allow_merge_if_all_discussions_are_resolved = true
      merge_method                                     = "ff"
      squash_option                                    = "always"
      remove_source_branch_after_merge                 = true

      # Custom templates (use %%{ to escape GitLab's template syntax)
      merge_commit_template  = "Merge branch '%%{source_branch}' into '%%{target_branch}'\n\nMerge request: %%{url}"
      squash_commit_template = "%%{title}\n\n%%{description}"
    }

    # -----------------------------------------------------------------------------
    # Project with Pipeline Trigger
    # -----------------------------------------------------------------------------
    "tf-test-pipeline-trigger" = {
      description            = "Project with a pipeline trigger token"
      namespace_id           = data.gitlab_group.main_group.id
      initialize_with_readme = true

      # Pipeline trigger - creates a trigger token for external CI/CD integrations
      pipeline_trigger = "External CI trigger"
    }
  }

  # Also load projects from YAML file
  projects_file = "${path.module}/projects.yml"
}

# =============================================================================
# Outputs
# =============================================================================

output "project_ids" {
  description = "Map of project names to IDs"
  value       = module.projects.project_ids
}

output "project_web_urls" {
  description = "Map of project names to web URLs"
  value       = module.projects.project_web_urls
}

output "project_ssh_urls" {
  description = "Map of project names to SSH clone URLs"
  value       = module.projects.project_ssh_urls_to_repo
}

output "milestones" {
  description = "Milestones created for each project"
  value       = module.projects.milestones
}

output "labels" {
  description = "Labels created for each project"
  value       = module.projects.labels
}

output "badges" {
  description = "Badges created for each project"
  value       = module.projects.badges
}

output "issues" {
  description = "Issues created for each project"
  value       = module.projects.issues
}

output "pipeline_triggers" {
  description = "Pipeline triggers created for each project"
  value       = module.projects.pipeline_triggers
  sensitive   = true
}
