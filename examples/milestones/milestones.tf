module "milestones" {
  source = "../../modules/milestones"

  project_id = data.gitlab_project.main_project.id

  milestones = {
    "v1.0.0" = {
      description = "Initial release"
      state       = "active"
      start_date  = "2025-01-01"
      due_date    = "2025-03-31"
    }
    "v1.1.0" = {
      description = "Minor improvements and bug fixes"
      start_date  = "2025-04-01"
      due_date    = "2025-06-30"
    }
    "v2.0.0" = {
      description = "Major release with breaking changes"
      start_date  = "2025-07-01"
      due_date    = "2025-12-31"
    }
    "Backlog" = {
      description = "Unscheduled work"
    }

    # Closed milestone
    "v0.9.0-beta" = {
      description = "Beta release - completed"
      state       = "closed"
      start_date  = "2024-10-01"
      due_date    = "2024-12-31"
    }

    # Milestone with only due_date
    "Q1 Deadline" = {
      description = "Q1 deliverables deadline"
      due_date    = "2025-03-31"
    }

    # Milestone with only start_date
    "Long-term Goals" = {
      description = "Ongoing long-term objectives"
      start_date  = "2025-01-01"
    }

    # Minimal milestone (title only, from map key)
    "Ideas" = {}
  }

  milestones_file = "${path.module}/milestones.yml"
}

module "milestones_create_only" {
  source = "../../modules/milestones"

  project_id  = data.gitlab_project.main_project.id
  create_only = true

  milestones = {
    "Sprint 1" = {
      description = "First sprint - immutable after creation"
      start_date  = "2025-01-06"
      due_date    = "2025-01-17"
    }
  }
}

output "milestones" {
  description = "Created milestones"
  value       = module.milestones.milestones
}
