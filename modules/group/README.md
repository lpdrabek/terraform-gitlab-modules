# GitLab Group Module

This Terraform module manages GitLab groups with comprehensive configuration options. It supports defining groups via Terraform configuration or YAML files.

## Features

- Create and manage GitLab groups with full configuration
- **Inline projects** - define projects inside groups, automatically created with correct namespace
- **Deploy tokens** - group-level and project-level deploy tokens
- YAML file support for easier group management
- Nested subgroups via parent_id
- Push rules configuration
- Branch protection defaults
- Security settings (2FA, IP restrictions)
- Create-only mode to prevent drift after initial creation

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0

## Important: GitLab.com Limitation

On GitLab.com, you cannot use this module to create top-level groups. Top-level groups must be created manually in the GitLab UI, then imported into your Terraform state.

```bash
# Import an existing top-level group
tofu import 'module.groups.gitlab_group.groups["my-organization"]' my-organization
```

After importing, you can manage the group using Terraform. Subgroups (groups with a `parent_id`) can be created directly without this limitation.

## Usage

### Basic Usage

```hcl
module "groups" {
  source  = "gitlab.com/gitlab-utl/group/gitlab"
  version = "~> 1.1"

  groups = {
    "my-team" = {
      description      = "My team's group"
      visibility_level = "private"
      project_creation_level  = "maintainer"
      subgroup_creation_level = "maintainer"
    }
  }
}
```

### Using YAML File

```hcl
module "groups" {
  source  = "gitlab.com/gitlab-utl/group/gitlab"
  version = "~> 1.1"

  groups_file = "./groups.yml"
}
```

Example `groups.yml`:

```yaml
my-organization:
  description: "Main organization group"
  visibility_level: private
  project_creation_level: maintainer
  subgroup_creation_level: maintainer

dev-team:
  description: "Development team"
  visibility_level: private
```

### YAML with Inline Projects

Define groups and their projects together in YAML:

```yaml
devops-team:
  description: "DevOps team with projects"
  visibility_level: private
  project_creation_level: maintainer

  projects:
    terraform-modules:
      description: "Shared Terraform modules"
      initialize_with_readme: true
      default_branch: main
      topics:
        - terraform
        - iac

    ansible-playbooks:
      description: "Ansible automation playbooks"
      initialize_with_readme: true
      push_rules:
        commit_message_regex: "^(feat|fix|docs):"
        prevent_secrets: true

    ci-templates:
      description: "CI/CD pipeline templates"
      builds_access_level: enabled
      shared_runners_enabled: true
```

This creates the group and all its projects in one definition.

### YAML with Projects, Labels, Milestones, Badges, Issues

Full example with all project features:

```yaml
engineering-team:
  description: "Engineering team"
  visibility_level: private

  projects:
    backend-api:
      description: "Backend API service"
      initialize_with_readme: true
      default_branch: main

      # Labels for the project
      labels:
        bug:
          color: "#FF0000"
          description: "Bug reports"
        feature:
          color: "#00FF00"
          description: "New features"
        documentation:
          color: "#0000FF"
          description: "Documentation updates"

      # Milestones
      milestones:
        v1.0:
          description: "Initial release"
          due_date: "2024-06-01"
        v1.1:
          description: "Bug fixes"
          start_date: "2024-06-01"
          due_date: "2024-07-01"

      # Badges
      badges:
        pipeline:
          link_url: "https://gitlab.com/group/project/pipelines"
          image_url: "https://gitlab.com/group/project/badges/main/pipeline.svg"
        coverage:
          link_url: "https://gitlab.com/group/project/coverage"
          image_url: "https://gitlab.com/group/project/badges/main/coverage.svg"

      # Issues
      issues:
        setup-ci:
          title: "Setup CI/CD pipeline"
          description: "Configure GitLab CI for automated testing"
          labels:
            priority:
              color: "#FFA500"
        write-docs:
          title: "Write API documentation"
          description: "Document all API endpoints"

      # Push rules
      push_rules:
        commit_message_regex: "^(feat|fix|docs):"
        prevent_secrets: true
```

### Nested Subgroups

```hcl
module "parent" {
  source  = "gitlab.com/gitlab-utl/group/gitlab"
  version = "~> 1.1"

  groups = {
    "organization" = {
      description = "Parent organization"
    }
  }
}

module "subgroups" {
  source  = "gitlab.com/gitlab-utl/group/gitlab"
  version = "~> 1.1"

  groups = {
    "backend" = {
      description = "Backend team"
      parent_id   = module.parent.group_ids["organization"]
    }
    "frontend" = {
      description = "Frontend team"
      parent_id   = module.parent.group_ids["organization"]
    }
  }
}
```

### With Push Rules

```hcl
module "groups" {
  source  = "gitlab.com/gitlab-utl/group/gitlab"
  version = "~> 1.1"

  groups = {
    "compliant-team" = {
      description      = "Team with commit compliance"
      visibility_level = "private"

      push_rules = {
        commit_message_regex = "^(feat|fix|docs|style|refactor|test|chore):"
        branch_name_regex    = "^(feature|bugfix|hotfix)/"
        prevent_secrets      = true
        max_file_size        = 50
      }
    }
  }
}
```

### With Security Settings

```hcl
module "groups" {
  source  = "gitlab.com/gitlab-utl/group/gitlab"
  version = "~> 1.1"

  groups = {
    "secure-team" = {
      description      = "High security team"
      visibility_level = "private"

      require_two_factor_authentication = true
      two_factor_grace_period           = 24
      membership_lock                   = true
      share_with_group_lock             = true
      prevent_forking_outside_group     = true
    }
  }
}
```

### With Group Deploy Tokens

```hcl
module "groups" {
  source  = "gitlab.com/gitlab-utl/group/gitlab"
  version = "~> 1.1"

  groups = {
    "my-team" = {
      description      = "Team with deploy tokens"
      visibility_level = "private"

      deploy_tokens = {
        "registry-read" = {
          scopes   = ["read_registry"]
          username = "registry-reader"
        }
        "package-access" = {
          scopes     = ["read_package_registry", "write_package_registry"]
          username   = "package-bot"
          expires_at = "2026-12-31T23:59:59Z"
        }
      }
    }
  }
}
```

### With Project Deploy Tokens (Inline Projects)

```hcl
module "groups" {
  source  = "gitlab.com/gitlab-utl/group/gitlab"
  version = "~> 1.1"

  groups = {
    "platform-team" = {
      description = "Team with projects and deploy tokens"

      projects = {
        "api-service" = {
          description = "Backend API"

          deploy_tokens = {
            "ci-deploy" = {
              scopes   = ["read_repository", "read_registry"]
              username = "ci-deployer"
            }
          }
        }
      }
    }
  }
}
```

### YAML with Deploy Tokens

```yaml
devops-team:
  description: "DevOps team"
  visibility_level: private

  # Group-level deploy tokens
  deploy_tokens:
    group-registry:
      scopes:
        - read_registry
        - write_registry
      username: group-registry-bot

  projects:
    infrastructure:
      description: "Infrastructure code"

      # Project-level deploy tokens
      deploy_tokens:
        terraform-token:
          scopes:
            - read_repository
          username: terraform-bot
```

### Create-Only Mode

```hcl
module "groups" {
  source  = "gitlab.com/gitlab-utl/group/gitlab"
  version = "~> 1.1"

  create_only = true

  groups = {
    "imported-group" = {
      description = "Don't manage after creation"
    }
  }
}
```

### Groups with Inline Projects

Define projects directly inside groups - they're automatically created with the correct namespace:

```hcl
module "my_team" {
  source  = "gitlab.com/gitlab-utl/group/gitlab"
  version = "~> 1.1"

  groups = {
    "platform-team" = {
      description      = "Platform engineering team"
      visibility_level = "private"

      projects = {
        "api-service" = {
          description            = "Backend API"
          initialize_with_readme = true
          default_branch         = "main"

          push_rules = {
            commit_message_regex = "^(feat|fix|docs):"
            prevent_secrets      = true
          }
        }
        "docs" = {
          description         = "Documentation"
          builds_access_level = "disabled"
        }
      }
    }
  }
}
```

This creates:
```
platform-team/
├── api-service
└── docs
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `groups` | Map of groups to create | `map(object({...}))` | `{}` | No |
| `groups_file` | Path to YAML file containing groups | `string` | `null` | No |
| `create_only` | If true, ignore attribute changes after creation | `bool` | `false` | No |

## Group Properties

### Core Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `path` | string | name | Group URL path |
| `description` | string | `null` | Group description |
| `parent_id` | number | `null` | Parent group ID for nested groups |
| `visibility_level` | string | `"private"` | `private`, `internal`, or `public` |
| `default_branch` | string | `null` | Default branch name |

### Access Control

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `project_creation_level` | string | `null` | `noone`, `owner`, `maintainer`, `developer` |
| `subgroup_creation_level` | string | `null` | `owner`, `maintainer` |
| `membership_lock` | bool | `null` | Prevent adding members to projects |
| `share_with_group_lock` | bool | `null` | Prevent sharing with other groups |
| `request_access_enabled` | bool | `true` | Allow access requests |
| `prevent_forking_outside_group` | bool | `false` | Prevent external forking |

### Features

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `auto_devops_enabled` | bool | `null` | Enable Auto DevOps |
| `lfs_enabled` | bool | `true` | Enable Git LFS |
| `emails_enabled` | bool | `true` | Enable email notifications |
| `mentions_disabled` | bool | `false` | Disable @mentions |
| `wiki_access_level` | string | `null` | Wiki access (Premium/Ultimate) |

### Security

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `require_two_factor_authentication` | bool | `false` | Require 2FA |
| `two_factor_grace_period` | number | `48` | Hours before 2FA enforced |
| `ip_restriction_ranges` | list(string) | `null` | Allowed IP ranges |
| `allowed_email_domains_list` | list(string) | `null` | Allowed email domains |

### Push Rules

| Property | Type | Description |
|----------|------|-------------|
| `commit_message_regex` | string | Regex for commit messages |
| `branch_name_regex` | string | Regex for branch names |
| `prevent_secrets` | bool | Prevent pushing secrets |
| `max_file_size` | number | Max file size in MB |

### Deploy Tokens (Group-Level)

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `deploy_tokens` | map | `{}` | Map of deploy tokens to create |
| `deploy_tokens_file` | string | `null` | Path to YAML file with deploy tokens |
| `deploy_tokens_create_only` | bool | `false` | Ignore changes after creation |

#### Deploy Token Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `scopes` | list(string) | - | Scopes for the token (required) |
| `username` | string | `gitlab+deploy-token-{n}` | Custom username |
| `expires_at` | string | `null` | Expiration in RFC3339 format |
| `validate_past_expiration_date` | bool | `null` | Validate past expiration |

Valid scopes: `read_repository`, `read_registry`, `write_registry`, `read_virtual_registry`, `write_virtual_registry`, `read_package_registry`, `write_package_registry`

## Outputs

| Name | Description |
|------|-------------|
| `groups` | Map of created groups with all attributes |
| `group_ids` | Map of group names to IDs |
| `group_full_paths` | Map of group names to full paths |

## GitLab Documentation

- [Groups](https://docs.gitlab.com/ee/user/group/)
- [Groups API](https://docs.gitlab.com/ee/api/groups.html)
- [Push Rules](https://docs.gitlab.com/ee/user/group/access_and_permissions.html#group-push-rules)
- [Deploy Tokens](https://docs.gitlab.com/ee/user/project/deploy_tokens/)
- [Group Deploy Tokens](https://docs.gitlab.com/ee/user/project/deploy_tokens/index.html#group-deploy-tokens)
