output "project_badges" {
  description = "Map of created project badges"
  value       = gitlab_project_badge.badges
}

output "group_badges" {
  description = "Map of created group badges"
  value       = gitlab_group_badge.badges
}

output "badges" {
  description = "Map of all created badges (project or group depending on target)"
  value       = var.target.type == "project" ? gitlab_project_badge.badges : gitlab_group_badge.badges
}
