# =============================================================================
# Access Token Module Examples
# =============================================================================

# -----------------------------------------------------------------------------
# Project Access Tokens - from YAML file
# -----------------------------------------------------------------------------
module "project_tokens_yaml" {
  source = "../../modules/access_token"

  target = {
    type = "project"
    id   = data.gitlab_project.main_project.id
  }

  access_tokens_file = "${path.module}/tokens.yml"
}

# -----------------------------------------------------------------------------
# Project Access Tokens - inline HCL
# -----------------------------------------------------------------------------
module "project_tokens_inline" {
  source = "../../modules/access_token"

  target = {
    type = "project"
    id   = data.gitlab_project.main_project.id
  }

  access_tokens = {
    "deploy-token" = {
      scopes       = ["read_repository", "write_repository"]
      access_level = "maintainer"
      description  = "Token for deployment automation"
      expires_at   = "2026-12-31"
    }
    "api-token" = {
      scopes       = ["api"]
      access_level = "developer"
      description  = "Full API access token"
      expires_at   = "2026-12-31"
    }
  }
}

# -----------------------------------------------------------------------------
# Group Access Tokens
# -----------------------------------------------------------------------------
module "group_tokens" {
  source = "../../modules/access_token"

  target = {
    type = "group"
    id   = data.gitlab_group.main_group.id
  }

  access_tokens = {
    "group-ci-token" = {
      scopes       = ["read_api", "read_repository"]
      access_level = "reporter"
      description  = "Group-level CI token"
      expires_at   = "2026-12-31"
    }
  }
}

# =============================================================================
# Outputs
# =============================================================================

output "project_tokens_yaml" {
  description = "Project tokens created from YAML"
  value       = module.project_tokens_yaml.tokens
  sensitive   = true
}

output "project_tokens_inline" {
  description = "Project tokens created inline"
  value       = module.project_tokens_inline.tokens
  sensitive   = true
}

output "group_tokens" {
  description = "Group tokens"
  value       = module.group_tokens.tokens
  sensitive   = true
}

# Example of getting just the token values
output "deploy_token_value" {
  description = "The deploy token secret value"
  value       = module.project_tokens_inline.token_values["deploy-token"]
  sensitive   = true
}
