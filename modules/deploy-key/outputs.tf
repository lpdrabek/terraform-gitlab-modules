output "deploy_keys" {
  description = "Map of created deploy keys with their attributes"
  value       = var.create_only ? gitlab_deploy_key.create_only_deploy_keys : gitlab_deploy_key.deploy_keys
}

output "deploy_key_ids" {
  description = "Map of deploy key titles to their deploy key IDs"
  value = var.create_only ? {
    for k, v in gitlab_deploy_key.create_only_deploy_keys : k => v.deploy_key_id
    } : {
    for k, v in gitlab_deploy_key.deploy_keys : k => v.deploy_key_id
  }
}

output "enabled_keys" {
  description = "Map of enabled deploy keys with their attributes (keyed by name:project)"
  value       = var.create_only ? gitlab_deploy_key_enable.create_only_enable_keys : gitlab_deploy_key_enable.enable_keys
}
