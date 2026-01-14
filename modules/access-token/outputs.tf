output "tokens" {
  description = "Map of created access tokens with their attributes"
  value = var.target.type == "project" ? gitlab_project_access_token.tokens : (
    var.target.type == "group" ? gitlab_group_access_token.tokens : gitlab_personal_access_token.tokens
  )
  sensitive = true
}

output "token_values" {
  description = "Map of token names to their secret values"
  value = var.target.type == "project" ? {
    for k, v in gitlab_project_access_token.tokens : k => v.token
    } : (
    var.target.type == "group" ? {
      for k, v in gitlab_group_access_token.tokens : k => v.token
      } : {
      for k, v in gitlab_personal_access_token.tokens : k => v.token
    }
  )
  sensitive = true
}
