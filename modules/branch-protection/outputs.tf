output "branch_protections" {
  description = "Map of created branch protections"
  value       = merge(gitlab_branch_protection.branches, gitlab_branch_protection.create_only_branches)
}

output "protected_branches" {
  description = "List of protected branch names"
  value       = keys(merge(gitlab_branch_protection.branches, gitlab_branch_protection.create_only_branches))
}
