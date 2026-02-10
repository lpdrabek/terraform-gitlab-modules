# =============================================================================
# Deploy Key Module Examples
# =============================================================================

# -----------------------------------------------------------------------------
# Project Deploy Keys - from YAML file
# -----------------------------------------------------------------------------
module "project_keys_yaml" {
  source = "../../modules/deploy-key"

  project = data.gitlab_project.main_project.id

  deploy_keys_file = "${path.module}/deploy_keys.yml"
}

# -----------------------------------------------------------------------------
# Project Deploy Keys - inline HCL
# -----------------------------------------------------------------------------
module "project_keys_inline" {
  source = "../../modules/deploy-key"

  project = data.gitlab_project.main_project.id

  deploy_keys = {
    "ci-read-only" = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICIreadonly"
    }
    "ci-push" = {
      key        = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICIpush"
      can_push   = true
      expires_at = "2026-12-31T23:59:59Z"
    }
  }
}

# -----------------------------------------------------------------------------
# Create a key and enable it on additional projects
# -----------------------------------------------------------------------------
module "shared_key" {
  source = "../../modules/deploy-key"

  project = data.gitlab_project.main_project.id

  deploy_keys = {
    "shared-ci-key" = {
      key    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIShared"
      enable = [data.gitlab_project.secondary_project.id]
    }
  }
}

# -----------------------------------------------------------------------------
# Enable an existing key on multiple projects
# -----------------------------------------------------------------------------
module "enable_existing" {
  source = "../../modules/deploy-key"

  project = data.gitlab_project.main_project.id

  deploy_keys = {
    "reuse-ci-key" = {
      key_id = module.project_keys_inline.deploy_key_ids["ci-read-only"]
      enable = [data.gitlab_project.secondary_project.id]
    }
  }
}

# -----------------------------------------------------------------------------
# Project Deploy Keys - create_only mode
# -----------------------------------------------------------------------------
module "project_keys_create_only" {
  source = "../../modules/deploy-key"

  project     = data.gitlab_project.main_project.id
  create_only = true

  deploy_keys = {
    "immutable-deploy-key" = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImmutable"
    }
  }
}

# =============================================================================
# Outputs
# =============================================================================

output "project_keys_yaml" {
  description = "Project deploy keys created from YAML"
  value       = module.project_keys_yaml.deploy_keys
}

output "project_keys_inline" {
  description = "Project deploy keys created inline"
  value       = module.project_keys_inline.deploy_keys
}

output "project_key_ids" {
  description = "Project deploy key IDs"
  value       = module.project_keys_inline.deploy_key_ids
}

output "shared_key_enabled" {
  description = "Deploy keys enabled on additional projects"
  value       = module.shared_key.enabled_keys
}

output "enable_existing" {
  description = "Existing deploy keys enabled on projects"
  value       = module.enable_existing.enabled_keys
}

output "project_keys_create_only" {
  description = "Project deploy keys in create_only mode"
  value       = module.project_keys_create_only.deploy_keys
}
