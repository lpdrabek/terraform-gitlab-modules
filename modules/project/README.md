# GitLab Project Module

This Terraform module manages GitLab projects with comprehensive configuration options. It supports defining projects via Terraform configuration or YAML files, including nested resources like milestones, labels, badges, and issues.

## Features

- Create and manage GitLab projects with full configuration
- YAML file support for easier project management
- Nested resource management (milestones, labels, badges, issues, deploy tokens)
- Push and pull mirror configuration
- Push rules configuration
- Container expiration policy
- Pipeline trigger configuration
- Create-only mode to prevent drift after initial creation

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0

## Usage

### Basic Usage

```hcl
module "projects" {
  source  = "gitlab.com/gitlab-utl/project/gitlab"
  version = "~> 1.1"

  projects = {
    "my-project" = {
      description      = "My awesome project"
      namespace_id     = gitlab_group.my_group.id
      visibility_level = "private"
      default_branch   = "main"

      # Merge Request Settings
      merge_method                          = "merge"
      squash_option                         = "default_off"
      remove_source_branch_after_merge      = true
      only_allow_merge_if_pipeline_succeeds = true
    }
  }
}
```

### Using YAML File

```hcl
module "projects" {
  source  = "gitlab.com/gitlab-utl/project/gitlab"
  version = "~> 1.1"

  projects_file = "./projects.yml"
}
```

Example `projects.yml`:

```yaml
my-project:
  description: "My awesome project"
  namespace_id: 12345
  visibility_level: private
  default_branch: main
  merge_method: merge
  squash_option: default_off
  remove_source_branch_after_merge: true

another-project:
  description: "Another project"
  namespace_id: 12345
  visibility_level: internal
  initialize_with_readme: true
```

### With Push Rules

```hcl
module "projects" {
  source  = "gitlab.com/gitlab-utl/project/gitlab"
  version = "~> 1.1"

  projects = {
    "secure-project" = {
      description      = "Project with push rules"
      namespace_id     = gitlab_group.my_group.id
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
```

### With Nested Resources

```hcl
module "projects" {
  source  = "gitlab.com/gitlab-utl/project/gitlab"
  version = "~> 1.1"

  projects = {
    "full-project" = {
      description      = "Project with all resources"
      namespace_id     = gitlab_group.my_group.id
      visibility_level = "private"

      # Labels
      labels = {
        bug = {
          color       = "#FF0000"
          description = "Something isn't working"
        }
        enhancement = {
          color       = "#00FF00"
          description = "New feature"
        }
      }

      # Milestones
      milestones = {
        "v1.0" = {
          description = "First release"
          due_date    = "2025-06-30"
        }
      }

      # Badges
      badges = {
        pipeline = {
          link_url  = "https://gitlab.com/my-group/full-project/-/pipelines"
          image_url = "https://gitlab.com/my-group/full-project/badges/main/pipeline.svg"
        }
      }
    }
  }
}
```

### With Push Mirror

```hcl
module "projects" {
  source  = "gitlab.com/gitlab-utl/project/gitlab"
  version = "~> 1.1"

  projects = {
    "mirrored-project" = {
      description      = "Project mirrored to GitHub"
      namespace_id     = gitlab_group.my_group.id
      visibility_level = "private"

      push_mirror = {
        url                     = "https://github.com/example/mirror-repo.git"
        auth_method             = "password"
        enabled                 = true
        only_protected_branches = true
      }
    }
  }
}
```

### With Pull Mirror

```hcl
module "projects" {
  source  = "gitlab.com/gitlab-utl/project/gitlab"
  version = "~> 1.1"

  projects = {
    "synced-project" = {
      description      = "Project synced from GitHub"
      namespace_id     = gitlab_group.my_group.id
      visibility_level = "private"

      pull_mirror = {
        url                   = "https://github.com/example/source-repo.git"
        auth_user             = "oauth2"
        auth_password         = var.github_token
        mirror_trigger_builds = true
      }
    }
  }
}
```

### With Deploy Tokens

```hcl
module "projects" {
  source  = "gitlab.com/gitlab-utl/project/gitlab"
  version = "~> 1.1"

  projects = {
    "project-with-tokens" = {
      description      = "Project with deploy tokens"
      namespace_id     = gitlab_group.my_group.id
      visibility_level = "private"

      deploy_tokens = {
        "ci-deploy" = {
          scopes   = ["read_repository", "read_registry"]
          username = "ci-deployer"
        }
        "registry-push" = {
          scopes     = ["read_registry", "write_registry"]
          username   = "registry-pusher"
          expires_at = "2026-12-31T23:59:59Z"
        }
      }
    }
  }
}
```

### With Deploy Tokens from YAML File

```hcl
module "projects" {
  source  = "gitlab.com/gitlab-utl/project/gitlab"
  version = "~> 1.1"

  projects = {
    "project-with-tokens" = {
      description        = "Project with deploy tokens from file"
      namespace_id       = gitlab_group.my_group.id
      deploy_tokens_file = "./deploy-tokens.yml"
    }
  }
}
```

Example `deploy-tokens.yml`:

```yaml
ci-deploy:
  scopes:
    - read_repository
    - read_registry
  username: ci-deployer

registry-push:
  scopes:
    - read_registry
    - write_registry
  expires_at: "2026-12-31T23:59:59Z"
```

### With Pipeline Trigger

```hcl
module "projects" {
  source  = "gitlab.com/gitlab-utl/project/gitlab"
  version = "~> 1.1"

  projects = {
    "triggered-project" = {
      description      = "Project with pipeline trigger"
      namespace_id     = gitlab_group.my_group.id
      visibility_level = "private"

      pipeline_trigger = "External CI trigger"
    }
  }
}
```

### Create-Only Mode

```hcl
module "projects" {
  source  = "gitlab.com/gitlab-utl/project/gitlab"
  version = "~> 1.1"

  create_only = true

  projects = {
    "imported-project" = {
      description      = "Imported project - don't manage after creation"
      namespace_id     = gitlab_group.my_group.id
      visibility_level = "private"
    }
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `projects` | Map of projects to create | `map(object({...}))` | `{}` | No |
| `projects_file` | Path to YAML file containing projects | `string` | `null` | No |
| `create_only` | If true, ignore attribute changes after creation | `bool` | `false` | No |

## Project Properties

### Core Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `description` | string | `null` | Project description |
| `namespace_id` | number | `null` | Namespace (group) ID |
| `path` | string | `null` | Project path (defaults to name) |
| `visibility_level` | string | `"private"` | `private`, `internal`, or `public` |
| `default_branch` | string | `null` | Default branch name |

### Repository Configuration

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `import_url` | string | `null` | URL to import repository from |
| `mirror` | bool | `null` | Enable repository mirroring |
| `initialize_with_readme` | bool | `false` | Initialize with README |
| `forked_from_project_id` | number | `null` | Fork from this project |

### CI/CD Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `ci_config_path` | string | `null` | Path to CI config file |
| `build_timeout` | number | `3600` | Build timeout in seconds |
| `shared_runners_enabled` | bool | `true` | Enable shared runners |
| `auto_devops_enabled` | bool | `null` | Enable Auto DevOps |

### Merge Request Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `merge_method` | string | `"merge"` | `merge`, `rebase_merge`, or `ff` |
| `squash_option` | string | `"default_off"` | `never`, `always`, `default_on`, `default_off` |
| `only_allow_merge_if_pipeline_succeeds` | bool | `false` | Require passing pipeline |
| `remove_source_branch_after_merge` | bool | `false` | Delete source branch after merge |

### Push Rules

| Property | Type | Description |
|----------|------|-------------|
| `commit_message_regex` | string | Regex for commit messages |
| `branch_name_regex` | string | Regex for branch names |
| `prevent_secrets` | bool | Prevent pushing secrets |
| `max_file_size` | number | Max file size in MB |

### Push Mirror

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `url` | string | - | URL of the remote repository to push to (required) |
| `auth_method` | string | `null` | Authentication method: `ssh_public_key` or `password` |
| `enabled` | bool | `true` | Whether the mirror is enabled |
| `keep_divergent_refs` | bool | `null` | Skip divergent refs instead of failing |
| `only_protected_branches` | bool | `null` | Only mirror protected branches |
| `mirror_branch_regex` | string | `null` | Regex for branches to mirror (Premium/Ultimate) |

### Pull Mirror

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `url` | string | - | URL of the remote repository to pull from (required) |
| `auth_user` | string | `null` | Username for authentication |
| `auth_password` | string | `null` | Password or token for authentication |
| `enabled` | bool | `true` | Whether the mirror is enabled |
| `mirror_overwrites_diverged_branches` | bool | `null` | Overwrite diverged branches |
| `mirror_trigger_builds` | bool | `null` | Trigger pipelines when mirror updates |
| `only_mirror_protected_branches` | bool | `null` | Only mirror protected branches |
| `mirror_branch_regex` | string | `null` | Regex for branches to mirror (Premium/Ultimate) |

### Deploy Tokens

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `scopes` | list(string) | - | Scopes for the token (required) |
| `username` | string | `gitlab+deploy-token-{n}` | Custom username for the token |
| `expires_at` | string | `null` | Expiration date in RFC3339 format |
| `validate_past_expiration_date` | bool | `null` | Whether to validate past expiration dates |

Valid scopes: `read_repository`, `read_registry`, `write_registry`, `read_virtual_registry`, `write_virtual_registry`, `read_package_registry`, `write_package_registry`

### Pipeline Trigger

| Property | Type | Description |
|----------|------|-------------|
| `pipeline_trigger` | string | Description for the pipeline trigger token |

### Nested Resources

| Property | Type | Description |
|----------|------|-------------|
| `labels` | map | Project labels |
| `milestones` | map | Project milestones |
| `badges` | map | Project badges |
| `issues` | map | Project issues |
| `deploy_tokens` | map | Project deploy tokens |
| `labels_file` | string | Path to labels YAML file |
| `milestones_file` | string | Path to milestones YAML file |
| `badges_file` | string | Path to badges YAML file |
| `issues_file` | string | Path to issues YAML file |
| `deploy_tokens_file` | string | Path to deploy tokens YAML file |

## Outputs

| Name | Description |
|------|-------------|
| `projects` | Map of created projects with their details |
| `project_ids` | Map of project names to IDs |

## GitLab Documentation

- [Projects](https://docs.gitlab.com/ee/user/project/)
- [Projects API](https://docs.gitlab.com/ee/api/projects.html)
- [Push Rules](https://docs.gitlab.com/ee/user/project/repository/push_rules.html)
- [Repository Mirroring](https://docs.gitlab.com/ee/user/project/repository/mirror/)
- [Deploy Tokens](https://docs.gitlab.com/ee/user/project/deploy_tokens/)
- [Pipeline Triggers](https://docs.gitlab.com/ee/ci/triggers/)
