# Branch Module Example

This example demonstrates the GitLab branch module which creates and manages branches in a project.

## Features Tested

### Branches from YAML (`branches.yml`)

| Branch | Created From | Keep on Destroy |
|--------|--------------|-----------------|
| `develop` | main | No |
| `staging` | main | No |
| `feature/user-auth` | develop | No |
| `feature/api-v2` | develop | Yes |
| `release/v1.0` | main | Yes |

## Usage

```bash
# Set your GitLab token
export TF_VAR_gitlab_token="your-token-here"

# Optional: Use a different GitLab instance
export TF_VAR_gitlab_base_url="https://gitlab.example.com"

# Initialize and apply
tofu init
tofu plan
tofu apply
```

## Requirements

- GitLab API token with `api` scope
- Developer or higher access to target project
- The `create_from` ref (branch, tag, or commit) must exist

## Module Features

The branch module supports:

- **Creating branches** from existing branches, tags, or commits
- **YAML file loading** for external configuration
- **Keep on destroy** option to preserve branches when Terraform resources are destroyed
- **Lifecycle ignore** for ref changes (prevents recreation when source branch diverges)

## Branch Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `create_from` | string | Yes | The ref (branch, tag, or commit SHA) to create the branch from |
| `keep_on_destroy` | bool | No | If true, the branch is not deleted when the resource is destroyed |

## Creating Branches From Different Sources

### From a branch

```yaml
develop:
  create_from: main
```

### From a tag

```yaml
hotfix/v1.0.1:
  create_from: v1.0.0
```

### From a commit SHA

```yaml
bugfix/legacy:
  create_from: abc123def456789
```

## YAML Format

```yaml
# Key is the branch name to create
branch-name:
  create_from: main
  keep_on_destroy: false  # Optional, defaults to null (false)

another-branch:
  create_from: develop
  keep_on_destroy: true
```

## Inline HCL Format

```hcl
module "branches" {
  source = "gitlab.com/gitlab-utl/branch/gitlab"

  project = "my-group/my-project"

  branches = {
    "develop" = {
      create_from = "main"
    }
    "feature/new-feature" = {
      create_from     = "develop"
      keep_on_destroy = true
    }
  }
}
```

## Mixed YAML and Inline

You can use both YAML and inline definitions. Inline definitions take precedence for duplicate branch names:

```hcl
module "branches" {
  source = "gitlab.com/gitlab-utl/branch/gitlab"

  project       = "my-group/my-project"
  branches_file = "./branches.yml"

  branches = {
    # This will override if 'develop' exists in branches.yml
    "develop" = {
      create_from = "main"
    }
  }
}
```

## Cleanup

```bash
tofu destroy
```

Note: Branches with `keep_on_destroy = true` will not be deleted when destroyed. You'll need to delete them manually in GitLab.
