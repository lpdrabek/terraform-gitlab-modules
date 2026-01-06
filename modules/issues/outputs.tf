output "milestones" {
  description = "Map of milestones used by issues (either created or fetched from existing)"
  value       = local.all_milestones_map
}

output "issues" {
  description = "Map of created issues with their attributes"
  value = var.create_only ? {
    for key, issue in gitlab_project_issue.create_only_issues :
    key => issue
    } : {
    for key, issue in gitlab_project_issue.issues :
    key => issue
  }
}
