# Branch Protection Module Example

This example demonstrates the GitLab branch protection module which manages branch protection rules for projects.

## Features Tested

### Branch Protection from YAML (`branches.yml`)

| Branch | Push Access | Merge Access | Unprotect Access | Force Push |
|--------|-------------|--------------|------------------|------------|
| `main` | maintainer | developer | maintainer | No |
| `develop` | developer | developer | - | No |

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
- Owner or Maintainer access to target project
- Branches must exist before protection can be applied (or use wildcards like `feature/*`)

## Module Features

The branch protection module supports:

- **Access level protection** for push, merge, and unprotect operations
- **YAML file loading** for external configuration
- **User-level permissions** (Premium/Ultimate only)
- **Group-level permissions** (Premium/Ultimate only)
- **Create-only mode** to prevent drift after initial creation

## Access Levels

| Level | Description |
|-------|-------------|
| `no one` | No one can perform this action |
| `developer` | Developers and above |
| `maintainer` | Maintainers and above |

## GitLab Tier Requirements

### Free Tier Features

- `push_access_level` - Control who can push
- `merge_access_level` - Control who can merge
- `unprotect_access_level` - Control who can unprotect
- `allow_force_push` - Allow/disallow force push

### Premium/Ultimate Only Features

- `allowed_to_push` - Specific users allowed to push
- `allowed_to_merge` - Specific users allowed to merge
- `allowed_to_unprotect` - Specific users allowed to unprotect
- `groups_allowed_to_push` - Specific groups allowed to push
- `groups_allowed_to_merge` - Specific groups allowed to merge
- `groups_allowed_to_unprotect` - Specific groups allowed to unprotect
- `code_owner_approval_required` - Require code owner approval

> **Note:** Using Premium/Ultimate features on Free tier will result in API errors.

## YAML Format

```yaml
# Key is the branch name (supports wildcards like release/*)
main:
  push_access_level: maintainer
  merge_access_level: developer
  unprotect_access_level: maintainer
  allow_force_push: false

develop:
  push_access_level: developer
  merge_access_level: developer
  allow_force_push: false

# Premium/Ultimate only - user-level permissions
# main:
#   search_by: username
#   push_access_level: maintainer
#   allowed_to_push:
#     - admin_user
#   allowed_to_merge:
#     - dev_user
```

## User/Group Lookup Methods

| Method | Description | Example | Use Case |
|--------|-------------|---------|----------|
| `email` | Look up user by email | `user@example.com` | User permissions |
| `username` | Look up user by GitLab username | `johndoe` | User permissions |
| `userid` | Use GitLab user ID directly | `12345` | User permissions |
| `groupid` | Use GitLab group ID directly | `67890` | Group permissions |
| `fullpath` | Look up group by full path | `my-group/subgroup` | Group permissions |

## Cleanup

```bash
tofu destroy
```

Note: Destroying branch protections will immediately remove protection from the affected branches.
