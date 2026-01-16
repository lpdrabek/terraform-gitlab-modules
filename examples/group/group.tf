# Example: YAML-based group creation
module "groups_yaml" {
  source = "../../modules/group"

  groups_file = "${path.module}/groups.yml"
}

# Example: Inline group creation
module "groups_inline" {
  source = "../../modules/group"

  groups = {
    "my-team" = {
      description      = "My team's group"
      visibility_level = "private"

      # Access control
      project_creation_level  = "maintainer"
      subgroup_creation_level = "maintainer"
      request_access_enabled  = true

      # Features
      lfs_enabled         = true
      emails_enabled      = true
      auto_devops_enabled = false
    }
  }
}

# Example: Nested subgroups
module "subgroups" {
  source = "../../modules/group"

  groups = {
    "backend" = {
      description      = "Backend team"
      parent_id        = module.groups_yaml.group_ids["my-organization"]
      visibility_level = "private"
    }
    "frontend" = {
      description      = "Frontend team"
      parent_id        = module.groups_yaml.group_ids["my-organization"]
      visibility_level = "private"
    }
  }
}

# Example: Group with push rules
module "groups_with_push_rules" {
  source = "../../modules/group"

  groups = {
    "secure-group" = {
      description      = "Group with enforced push rules"
      visibility_level = "private"

      push_rules = {
        commit_message_regex = "^(feat|fix|docs|style|refactor|test|chore):"
        branch_name_regex    = "^(feature|bugfix|hotfix)/"
        prevent_secrets      = true
        max_file_size        = 10
      }
    }
  }
}

# Example: Group with security settings
module "groups_secure" {
  source = "../../modules/group"

  groups = {
    "high-security" = {
      description      = "High security group"
      visibility_level = "private"

      # Security
      require_two_factor_authentication = true
      two_factor_grace_period           = 24
      membership_lock                   = true
      share_with_group_lock             = true
      prevent_forking_outside_group     = true
    }
  }
}

# Example: Create-only mode (ignores changes after initial creation)
module "groups_create_only" {
  source = "../../modules/group"

  create_only = true

  groups = {
    "imported-group" = {
      description      = "Imported group - don't manage after creation"
      visibility_level = "private"
    }
  }
}

# Example: Group with inline projects
# Creates a group with projects inside - no need for separate module calls
module "platform_team" {
  source = "../../modules/group"

  groups = {
    "platform-team" = {
      description             = "Platform engineering team"
      parent_id               = data.gitlab_group.main_group.id
      visibility_level        = "private"
      project_creation_level  = "maintainer"
      subgroup_creation_level = "maintainer"

      # Projects created inside this group automatically
      projects = {
        "infrastructure" = {
          description                           = "Infrastructure as Code repository"
          initialize_with_readme                = true
          default_branch                        = "main"
          merge_method                          = "merge"
          squash_option                         = "default_on"
          remove_source_branch_after_merge      = true
          only_allow_merge_if_pipeline_succeeds = true
        }
        "shared-libraries" = {
          description            = "Shared libraries and utilities"
          initialize_with_readme = true
          default_branch         = "main"
          topics                 = ["library", "shared"]
        }
        "documentation" = {
          description            = "Team documentation and runbooks"
          initialize_with_readme = true
          default_branch         = "main"
          builds_access_level    = "disabled"
        }
      }
    }
  }
}
