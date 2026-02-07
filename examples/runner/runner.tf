# =============================================================================
# Runner Module Examples
# =============================================================================

# -----------------------------------------------------------------------------
# Project Runners - from YAML file
# -----------------------------------------------------------------------------
module "project_runners_yaml" {
  source = "../../modules/runner"

  runners_file = "${path.module}/runners.yml"
}

# -----------------------------------------------------------------------------
# Project Runners - inline HCL
# -----------------------------------------------------------------------------
module "project_runners_inline" {
  source = "../../modules/runner"

  runners = {
    "docker-runner" = {
      runner_type  = "project_type"
      project_id   = data.gitlab_project.main_project.id
      description  = "Docker executor for CI/CD pipelines"
      tag_list     = ["docker", "linux", "amd64"]
      access_level = "not_protected"
      untagged     = false
    }
    "shell-runner" = {
      runner_type     = "project_type"
      project_id      = data.gitlab_project.main_project.id
      description     = "Shell executor for local scripts"
      tag_list        = ["shell", "linux"]
      access_level    = "ref_protected"
      locked          = true
      maximum_timeout = 1800
    }
  }
}

# -----------------------------------------------------------------------------
# Group Runners
# -----------------------------------------------------------------------------
module "group_runners" {
  source = "../../modules/runner"

  runners = {
    "shared-group-runner" = {
      runner_type      = "group_type"
      group_id         = data.gitlab_group.main_group.id
      description      = "Shared runner for all group projects"
      tag_list         = ["shared", "docker"]
      access_level     = "not_protected"
      untagged         = true
      maintenance_note = "Shared runner for tf-tests group"
    }
  }
}

# -----------------------------------------------------------------------------
# Instance Runners (requires admin access)
# -----------------------------------------------------------------------------
# module "instance_runners" {
#   source = "../../modules/runner"
#
#   runners = {
#     "global-runner" = {
#       runner_type      = "instance_type"
#       description      = "Global instance runner"
#       tag_list         = ["global", "docker"]
#       access_level     = "not_protected"
#       untagged         = true
#       maintenance_note = "Global shared runner for all projects"
#     }
#   }
# }

# -----------------------------------------------------------------------------
# Create-only mode (ignore changes after creation)
# -----------------------------------------------------------------------------
module "immutable_runners" {
  source = "../../modules/runner"

  create_only = true

  runners = {
    "immutable-runner" = {
      runner_type = "project_type"
      project_id  = data.gitlab_project.main_project.id
      description = "Runner that won't be updated after creation"
      tag_list    = ["immutable"]
    }
  }
}

# =============================================================================
# Outputs
# =============================================================================

output "project_runners_yaml" {
  description = "Project runners created from YAML"
  value       = module.project_runners_yaml.runners
}

output "project_runners_yaml_ids" {
  description = "Project runner IDs from YAML"
  value       = module.project_runners_yaml.runner_ids
}

output "project_runners_yaml_tokens" {
  description = "Project runner tokens from YAML"
  value       = module.project_runners_yaml.runner_tokens
  sensitive   = true
}

output "project_runners_inline" {
  description = "Project runners created inline"
  value       = module.project_runners_inline.runners
}

output "project_runners_inline_ids" {
  description = "Project runner IDs from inline config"
  value       = module.project_runners_inline.runner_ids
}

output "project_runners_inline_tokens" {
  description = "Project runner tokens from inline config"
  value       = module.project_runners_inline.runner_tokens
  sensitive   = true
}

output "group_runners" {
  description = "Group runners"
  value       = module.group_runners.runners
}

output "group_runner_ids" {
  description = "Group runner IDs"
  value       = module.group_runners.runner_ids
}

output "group_runner_tokens" {
  description = "Group runner tokens"
  value       = module.group_runners.runner_tokens
  sensitive   = true
}

output "immutable_runners" {
  description = "Immutable runners (create-only mode)"
  value       = module.immutable_runners.runners
}

output "immutable_runner_ids" {
  description = "Immutable runner IDs"
  value       = module.immutable_runners.runner_ids
}

output "immutable_runner_tokens" {
  description = "Immutable runner tokens"
  value       = module.immutable_runners.runner_tokens
  sensitive   = true
}
