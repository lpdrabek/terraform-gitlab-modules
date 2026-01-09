module "project_labels" {
  source = "../../modules/labels"

  target = {
    type = "project"
    id   = data.gitlab_project.main_project.id
  }

  labels = {
    bug = {
      color       = "#FF0000"
      description = "Something isn't working"
    }
    enhancement = {
      color       = "#5CB85C"
      description = "New feature or request"
    }
    "high-priority" = {
      color       = "#D9534F"
      description = "Critical issue requiring immediate attention"
    }
    "needs-triage" = {
      description = "Awaiting initial review"
    }
  }

  labels_file = "${path.module}/labels.yml"
}

module "group_labels" {
  source = "../../modules/labels"

  target = {
    type = "group"
    id   = data.gitlab_group.main_group.id
  }

  labels = {
    "team::backend" = {
      color       = "#428BCA"
      description = "Backend team ownership"
    }
    "team::frontend" = {
      color       = "#F0AD4E"
      description = "Frontend team ownership"
    }
  }
}

output "project_labels" {
  description = "Created project labels"
  value       = module.project_labels.labels
}

output "group_labels" {
  description = "Created group labels"
  value       = module.group_labels.labels
}
