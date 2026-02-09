output "tokens" {
  description = "Map of created deploy tokens with their attributes"
  value = var.target.type == "project" ? (
    var.create_only ? gitlab_project_deploy_token.create_only_project_tokens : gitlab_project_deploy_token.project_tokens
    ) : (
    var.create_only ? gitlab_group_deploy_token.create_only_group_tokens : gitlab_group_deploy_token.group_tokens
  )
  sensitive = true
}

output "token_values" {
  description = "Map of token names to their secret values"
  value = var.target.type == "project" ? (
    var.create_only ? {
      for k, v in gitlab_project_deploy_token.create_only_project_tokens : k => v.token
      } : {
      for k, v in gitlab_project_deploy_token.project_tokens : k => v.token
    }
    ) : (
    var.create_only ? {
      for k, v in gitlab_group_deploy_token.create_only_group_tokens : k => v.token
      } : {
      for k, v in gitlab_group_deploy_token.group_tokens : k => v.token
    }
  )
  sensitive = true
}
