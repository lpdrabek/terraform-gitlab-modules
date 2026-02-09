# =============================================================================
# Deploy Token Module Examples
# =============================================================================

# -----------------------------------------------------------------------------
# Project Deploy Tokens - from YAML file
# -----------------------------------------------------------------------------
module "project_tokens_yaml" {
  source = "../../modules/deploy-token"

  target = {
    type = "project"
    id   = data.gitlab_project.main_project.id
  }

  tokens_file = "${path.module}/tokens.yml"
}

# -----------------------------------------------------------------------------
# Project Deploy Tokens - inline HCL
# -----------------------------------------------------------------------------
module "project_tokens_inline" {
  source = "../../modules/deploy-token"

  target = {
    type = "project"
    id   = data.gitlab_project.main_project.id
  }

  tokens = {
    "ci-deploy" = {
      scopes   = ["read_repository", "read_registry"]
      username = "ci-deploy-user"
    }
    "registry-push" = {
      scopes     = ["read_registry", "write_registry"]
      username   = "registry-pusher"
      expires_at = "2026-12-31T23:59:59Z"
    }
  }
}

# -----------------------------------------------------------------------------
# Group Deploy Tokens
# -----------------------------------------------------------------------------
module "group_tokens" {
  source = "../../modules/deploy-token"

  target = {
    type = "group"
    id   = data.gitlab_group.main_group.id
  }

  tokens = {
    "group-registry-read" = {
      scopes   = ["read_registry"]
      username = "group-registry-reader"
    }
  }
}

# -----------------------------------------------------------------------------
# Project Deploy Tokens - create_only mode
# -----------------------------------------------------------------------------
module "project_tokens_create_only" {
  source = "../../modules/deploy-token"

  target = {
    type = "project"
    id   = data.gitlab_project.main_project.id
  }

  create_only = true

  tokens = {
    "immutable-deploy-token" = {
      scopes   = ["read_repository"]
      username = "immutable-deployer"
    }
  }
}

# =============================================================================
# Outputs
# =============================================================================

output "project_tokens_yaml" {
  description = "Project deploy tokens created from YAML"
  value       = module.project_tokens_yaml.tokens
  sensitive   = true
}

output "project_tokens_inline" {
  description = "Project deploy tokens created inline"
  value       = module.project_tokens_inline.tokens
  sensitive   = true
}

output "group_tokens" {
  description = "Group deploy tokens"
  value       = module.group_tokens.tokens
  sensitive   = true
}

output "project_tokens_create_only" {
  description = "Project deploy tokens in create_only mode"
  value       = module.project_tokens_create_only.tokens
  sensitive   = true
}

# Example of getting just the token values
output "ci_deploy_token_value" {
  description = "The CI deploy token secret value"
  value       = module.project_tokens_inline.token_values["ci-deploy"]
  sensitive   = true
}
