output "project_variables" {
  description = "Map of created project variables"
  value       = gitlab_project_variable.project_variables
  sensitive   = true
}

output "group_variables" {
  description = "Map of created group variables"
  value       = gitlab_group_variable.group_variables
  sensitive   = true
}

output "variables" {
  description = "Map of all created variables (project or group depending on target)"
  value       = var.target.type == "project" ? gitlab_project_variable.project_variables : gitlab_group_variable.group_variables
  sensitive   = true
}
