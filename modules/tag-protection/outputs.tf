output "tag_protections" {
  description = "Map of created tag protections"
  value       = merge(gitlab_tag_protection.tags, gitlab_tag_protection.create_only_tags)
}

output "protected_tags" {
  description = "List of protected tag patterns"
  value       = keys(merge(gitlab_tag_protection.tags, gitlab_tag_protection.create_only_tags))
}
