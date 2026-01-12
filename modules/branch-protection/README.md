# GitLab Branch Protection Module

This Terraform module manages GitLab branch protection rules for projects. It supports defining branch protection via Terraform configuration or YAML files, with flexible user and group lookups.

## Features

- Protect branches with configurable access levels
- YAML file support for easier configuration management
- User lookup by email, username, or user ID
- Group lookup by group ID or full path (Premium/Ultimate)
- Create-only mode to prevent drift after initial creation

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0

## Usage

### Basic Usage (Free Tier)

```hcl
module "branch_protection" {
  source = "./modules/branch-protection"

  project = gitlab_project.my_project.id

  branches = {
    "main" = {
      push_access_level      = "maintainer"
      merge_access_level     = "developer"
      unprotect_access_level = "maintainer"
      allow_force_push       = false
    }
    "develop" = {
      push_access_level  = "developer"
      merge_access_level = "developer"
      allow_force_push   = false
    }
  }
}
```

### Using YAML File

```hcl
module "branch_protection" {
  source = "./modules/branch-protection"

  project       = gitlab_project.my_project.id
  branches_file = "./branches.yml"
}
```

Example `branches.yml`:

```yaml
main:
  push_access_level: maintainer
  merge_access_level: developer
  unprotect_access_level: maintainer
  allow_force_push: false

develop:
  push_access_level: developer
  merge_access_level: developer
  allow_force_push: false
```

### User-Level Permissions (Premium/Ultimate)

```hcl
module "branch_protection" {
  source = "./modules/branch-protection"

  project = gitlab_project.my_project.id

  branches = {
    "main" = {
      search_by          = "username"
      push_access_level  = "maintainer"
      merge_access_level = "developer"
      allowed_to_push    = ["admin_user"]
      allowed_to_merge   = ["dev_user", "admin_user"]
    }
  }
}
```

### Group-Level Permissions (Premium/Ultimate)

```hcl
module "branch_protection" {
  source = "./modules/branch-protection"

  project = gitlab_project.my_project.id

  branches = {
    "release/*" = {
      search_by               = "fullpath"
      push_access_level       = "no one"
      merge_access_level      = "maintainer"
      groups_allowed_to_push  = ["my-group/release-managers"]
      groups_allowed_to_merge = ["my-group/release-managers"]
    }
  }
}
```

### Create-Only Mode

```hcl
module "branch_protection" {
  source = "./modules/branch-protection"

  project     = gitlab_project.my_project.id
  create_only = true

  branches = {
    "feature/*" = {
      push_access_level  = "developer"
      merge_access_level = "developer"
    }
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `project` | Project ID or path to apply branch protection to | `string` | - | Yes |
| `branches` | Map of branches and their protection settings | `map(object({...}))` | `{}` | No |
| `branches_file` | Path to YAML file containing branch protection configuration | `string` | `null` | No |
| `create_only` | If true, ignore attribute changes after creation | `bool` | `false` | No |

## Branch Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `search_by` | string | `"email"` | User/group lookup method: `email`, `username`, `userid`, `groupid`, `fullpath` |
| `push_access_level` | string | `null` | Who can push: `no one`, `developer`, `maintainer` |
| `merge_access_level` | string | `null` | Who can merge: `no one`, `developer`, `maintainer` |
| `unprotect_access_level` | string | `null` | Who can unprotect: `no one`, `developer`, `maintainer` |
| `allow_force_push` | bool | `false` | Allow force push to the branch |
| `code_owner_approval_required` | bool | `false` | Require code owner approval (Premium/Ultimate) |
| `allowed_to_push` | list(string) | `[]` | Users allowed to push (Premium/Ultimate) |
| `allowed_to_merge` | list(string) | `[]` | Users allowed to merge (Premium/Ultimate) |
| `allowed_to_unprotect` | list(string) | `[]` | Users allowed to unprotect (Premium/Ultimate) |
| `groups_allowed_to_push` | list(string) | `[]` | Groups allowed to push (Premium/Ultimate) |
| `groups_allowed_to_merge` | list(string) | `[]` | Groups allowed to merge (Premium/Ultimate) |
| `groups_allowed_to_unprotect` | list(string) | `[]` | Groups allowed to unprotect (Premium/Ultimate) |

## Outputs

| Name | Description |
|------|-------------|
| `branch_protections` | Map of created branch protections with their details |
| `protected_branches` | List of protected branch names |

## GitLab Tier Requirements

### Free Tier
- `push_access_level`, `merge_access_level`, `unprotect_access_level`
- `allow_force_push`

### Premium/Ultimate Only
- `allowed_to_push`, `allowed_to_merge`, `allowed_to_unprotect` (user-level)
- `groups_allowed_to_push`, `groups_allowed_to_merge`, `groups_allowed_to_unprotect`
- `code_owner_approval_required`

Using Premium/Ultimate features on Free tier will result in errors like:
- `"Push access levels user must be blank"`
- `"Merge access levels group must be blank"`

## GitLab Documentation

- [Protected Branches](https://docs.gitlab.com/ee/user/project/protected_branches.html)
- [Protected Branches API](https://docs.gitlab.com/ee/api/protected_branches.html)
