# Tag Protection Module Example

This example demonstrates the GitLab tag protection module which manages tag protection rules for projects.

## Features Tested

### Tag Protection from YAML (`tags.yml`)

| Tag Pattern | Create Access |
|-------------|---------------|
| `v*` | maintainer |
| `release-*` | maintainer |
| `dev-*` | developer |

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

## Module Features

The tag protection module supports:

- **Access level protection** for tag creation
- **YAML file loading** for external configuration
- **User-level permissions** (Premium/Ultimate only)
- **Group-level permissions** (Premium/Ultimate only)
- **Create-only mode** to prevent drift after initial creation

## Access Levels

| Level | Description |
|-------|-------------|
| `no one` | No one can create matching tags |
| `developer` | Developers and above |
| `maintainer` | Maintainers and above |

## GitLab Tier Requirements

### Free Tier Features

- `create_access_level` - Control who can create tags

### Premium/Ultimate Only Features

- `allowed_to_create` - Specific users allowed to create
- `groups_allowed_to_create` - Specific groups allowed to create

> **Note:** Using Premium/Ultimate features on Free tier will result in API errors.

## YAML Format

```yaml
# Key is the tag pattern (supports wildcards)
v*:
  create_access_level: maintainer

release-*:
  create_access_level: maintainer

# Premium/Ultimate only - user-level permissions
# v*:
#   search_by: username
#   create_access_level: no one
#   allowed_to_create:
#     - release_manager
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

Note: Destroying tag protections will immediately remove protection from the affected tag patterns.
