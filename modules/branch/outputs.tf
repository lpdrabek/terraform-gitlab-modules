output "branches" {
  description = "Map of created branches with their attributes"
  value       = gitlab_branch.project_branch
}

output "branch_names" {
  description = "List of created branch names"
  value       = keys(gitlab_branch.project_branch)
}
