# GitLab Branch Module

This Terraform module creates and manages branches in GitLab projects. It supports creating branches from existing branches, tags, or commit SHAs.

## Features

- Create branches from branches, tags, or commits
- YAML file support for easier branch management
- Keep on destroy option to preserve branches
- Lifecycle management to prevent recreation on ref changes

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.8.0, < 19.0.0

## Usage

### Basic Usage

```hcl
module "branches" {
  source  = "gitlab.com/gitlab-utl/branch/gitlab"
  version = "~> 1.0"

  project = "my-group/my-project"

  branches = {
    "develop" = {
      create_from = "main"
    }
    "staging" = {
      create_from = "main"
    }
  }
}
```

### Using YAML File

```hcl
module "branches" {
  source  = "gitlab.com/gitlab-utl/branch/gitlab"
  version = "~> 1.0"

  project       = "my-group/my-project"
  branches_file = "./branches.yml"
  branches      = {}
}
```

Example `branches.yml`:

```yaml
develop:
  create_from: main

staging:
  create_from: main

feature/user-auth:
  create_from: develop
  keep_on_destroy: true
```

### Create from Tag

```hcl
module "branches" {
  source  = "gitlab.com/gitlab-utl/branch/gitlab"
  version = "~> 1.0"

  project = "my-group/my-project"

  branches = {
    "hotfix/v1.0.1" = {
      create_from = "v1.0.0"  # Tag name
    }
  }
}
```

### Create from Commit

```hcl
module "branches" {
  source  = "gitlab.com/gitlab-utl/branch/gitlab"
  version = "~> 1.0"

  project = "my-group/my-project"

  branches = {
    "bugfix/legacy" = {
      create_from = "abc123def456"  # Commit SHA
    }
  }
}
```

### Keep Branch on Destroy

```hcl
module "branches" {
  source  = "gitlab.com/gitlab-utl/branch/gitlab"
  version = "~> 1.0"

  project = "my-group/my-project"

  branches = {
    "production" = {
      create_from     = "main"
      keep_on_destroy = true  # Branch won't be deleted on destroy
    }
  }
}
```

### Mixed YAML and Inline

```hcl
module "branches" {
  source  = "gitlab.com/gitlab-utl/branch/gitlab"
  version = "~> 1.0"

  project       = "my-group/my-project"
  branches_file = "./branches.yml"

  # Inline branches override YAML branches with same name
  branches = {
    "hotfix/urgent" = {
      create_from = "main"
    }
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `project` | Project ID or path to create branches in | `string` | - | Yes |
| `branches` | Map of branches to create | `map(object({...}))` | - | Yes |
| `branches_file` | Path to YAML file containing branches | `string` | `null` | No |

## Branch Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `create_from` | string | - | The ref (branch, tag, or commit SHA) to create from (required) |
| `keep_on_destroy` | bool | `null` | If true, branch is not deleted when resource is destroyed |

## Outputs

| Name | Description |
|------|-------------|
| `branches` | Map of created branches with all attributes |
| `branch_names` | List of created branch names |

## Notes

### Ref Changes

The module uses `lifecycle { ignore_changes = [ref] }` to prevent Terraform from trying to recreate branches when the source ref changes. This is because:

1. The `ref` attribute is only set during resource creation
2. Once a branch exists, its commits will diverge from the source
3. Recreating would delete the branch and all its commits

### Keep on Destroy

When `keep_on_destroy = true`:
- The branch will remain in GitLab when `terraform destroy` is run
- Useful for production or long-lived branches
- The branch must be deleted manually in GitLab if needed

## GitLab Documentation

- [Branches](https://docs.gitlab.com/ee/user/project/repository/branches/)
- [Branches API](https://docs.gitlab.com/ee/api/branches.html)
