output "project_badges" {
  description = "Map of created project badges"
  value       = var.create_only ? gitlab_project_badge.create_only_badges : gitlab_project_badge.badges
}

output "group_badges" {
  description = "Map of created group badges"
  value       = var.create_only ? gitlab_group_badge.create_only_badges : gitlab_group_badge.badges
}

output "badges" {
  description = "Map of all created badges (project or group depending on target)"
  value = var.target.type == "project" ? (
    var.create_only ? gitlab_project_badge.create_only_badges : gitlab_project_badge.badges
    ) : (
    var.create_only ? gitlab_group_badge.create_only_badges : gitlab_group_badge.badges
  )
}
