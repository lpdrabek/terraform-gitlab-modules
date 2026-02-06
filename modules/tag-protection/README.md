# GitLab Tag Protection Module

This Terraform module manages GitLab tag protection rules for projects. It supports defining tag protection via Terraform configuration or YAML files, with flexible user and group lookups.

## Features

- Protect tags with configurable access levels
- YAML file support for easier configuration management
- User lookup by email, username, or user ID (Premium/Ultimate)
- Group lookup by group ID or full path (Premium/Ultimate)
- Create-only mode to prevent drift after initial creation

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0

## Usage

### Basic Usage (Free Tier)

```hcl
module "tag_protection" {
  source  = "gitlab.com/gitlab-utl/tag-protection/gitlab"
  version = "~> 1.1"

  project = gitlab_project.my_project.id

  tags = {
    "v*" = {
      create_access_level = "maintainer"
    }
    "release-*" = {
      create_access_level = "maintainer"
    }
    "dev-*" = {
      create_access_level = "developer"
    }
  }
}
```

### Using YAML File

```hcl
module "tag_protection" {
  source  = "gitlab.com/gitlab-utl/tag-protection/gitlab"
  version = "~> 1.1"

  project   = gitlab_project.my_project.id
  tags_file = "./tags.yml"
}
```

Example `tags.yml`:

```yaml
v*:
  create_access_level: maintainer

release-*:
  create_access_level: maintainer

dev-*:
  create_access_level: developer
```

### User-Level Permissions (Premium/Ultimate)

```hcl
module "tag_protection" {
  source  = "gitlab.com/gitlab-utl/tag-protection/gitlab"
  version = "~> 1.1"

  project = gitlab_project.my_project.id

  tags = {
    "v*" = {
      search_by           = "username"
      create_access_level = "no one"
      allowed_to_create   = ["release_manager", "admin_user"]
    }
  }
}
```

### Group-Level Permissions (Premium/Ultimate)

```hcl
module "tag_protection" {
  source  = "gitlab.com/gitlab-utl/tag-protection/gitlab"
  version = "~> 1.1"

  project = gitlab_project.my_project.id

  tags = {
    "release-*" = {
      search_by                = "fullpath"
      create_access_level      = "no one"
      groups_allowed_to_create = ["my-group/release-managers"]
    }
  }
}
```

### Create-Only Mode

```hcl
module "tag_protection" {
  source  = "gitlab.com/gitlab-utl/tag-protection/gitlab"
  version = "~> 1.1"

  project     = gitlab_project.my_project.id
  create_only = true

  tags = {
    "legacy-*" = {
      create_access_level = "maintainer"
    }
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `project` | Project ID or path to apply tag protection to | `string` | - | Yes |
| `tags` | Map of tags and their protection settings | `map(object({...}))` | `{}` | No |
| `tags_file` | Path to YAML file containing tag protection configuration | `string` | `null` | No |
| `create_only` | If true, ignore attribute changes after creation | `bool` | `false` | No |

## Tag Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `search_by` | string | `"email"` | User/group lookup method: `email`, `username`, `userid`, `groupid`, `fullpath` |
| `create_access_level` | string | `null` | Who can create: `no one`, `developer`, `maintainer` |
| `allowed_to_create` | list(string) | `[]` | Users allowed to create (Premium/Ultimate) |
| `groups_allowed_to_create` | list(string) | `[]` | Groups allowed to create (Premium/Ultimate) |

## Outputs

| Name | Description |
|------|-------------|
| `tag_protections` | Map of created tag protections with their details |
| `protected_tags` | List of protected tag patterns |

## GitLab Tier Requirements

### Free Tier
- `create_access_level` - Control who can create tags

### Premium/Ultimate Only
- `allowed_to_create` (user-level)
- `groups_allowed_to_create` (group-level)

Using Premium/Ultimate features on Free tier will result in API errors.

## GitLab Documentation

- [Protected Tags](https://docs.gitlab.com/ee/user/project/protected_tags.html)
- [Protected Tags API](https://docs.gitlab.com/ee/api/protected_tags.html)
