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

output "issue_iids" {
  description = "Map of issue keys to their issue IDs (iid - the project-specific issue number)"
  value = var.create_only ? {
    for key, issue in gitlab_project_issue.create_only_issues :
    key => issue.iid
    } : {
    for key, issue in gitlab_project_issue.issues :
    key => issue.iid
  }
}

output "issue_web_urls" {
  description = "Map of issue keys to their web URLs"
  value = var.create_only ? {
    for key, issue in gitlab_project_issue.create_only_issues :
    key => issue.web_url
    } : {
    for key, issue in gitlab_project_issue.issues :
    key => issue.web_url
  }
}
