output "memberships" {
  description = "Map of created memberships"
  value       = var.target.type == "project" ? gitlab_project_membership.members : gitlab_group_membership.members
}

output "user_ids" {
  description = "Map of membership keys to resolved user IDs"
  value       = { for k, v in local.all_memberships : k => v.user_id }
}
