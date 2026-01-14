# TO TEST IN SELF_HOSTED

# Access Token Module Example

This example demonstrates the GitLab access token module which creates project, group, and personal access tokens with scope validation.

## Features Tested

### Project Tokens from YAML (`tokens.yml`)

| Token | Scopes | Access Level |
|-------|--------|--------------|
| `ci-token` | read_repository, write_repository | developer |
| `readonly-token` | read_api, read_repository | reporter |
| `registry-token` | read_registry, write_registry | developer |

### Project Tokens from HCL (`access_token.tf`)

| Token | Scopes | Access Level |
|-------|--------|--------------|
| `deploy-token` | read_repository, write_repository | maintainer |
| `api-token` | api | developer |

### Group Tokens from HCL (`access_token.tf`)

| Token | Scopes | Access Level |
|-------|--------|--------------|
| `group-ci-token` | read_api, read_repository | reporter |

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
- Maintainer or Owner access to target project/group

## Module Features

The access token module supports:

- **Project access tokens** via `gitlab_project_access_token`
- **Group access tokens** via `gitlab_group_access_token`
- **Personal access tokens** via `gitlab_personal_access_token`
- **YAML file loading** for external configuration
- **Scope validation** per token type with clear error messages
- **Access level validation** (not applicable to personal tokens)

## Valid Scopes

| Token Type | Valid Scopes |
|------------|--------------|
| **Personal** | api, read_user, read_api, read_repository, write_repository, read_registry, write_registry, read_virtual_registry, write_virtual_registry, sudo, admin_mode, create_runner, manage_runner, ai_features, k8s_proxy, self_rotate, read_service_ping |
| **Group** | api, read_api, read_registry, write_registry, read_virtual_registry, write_virtual_registry, read_repository, write_repository, create_runner, manage_runner, ai_features, k8s_proxy, read_observability, write_observability, self_rotate |
| **Project** | api, read_api, read_registry, write_registry, read_repository, write_repository, create_runner, manage_runner, ai_features, k8s_proxy, read_observability, write_observability, self_rotate |

## Valid Access Levels

For project and group tokens only:
- `no one`
- `minimal`
- `guest`
- `planner`
- `reporter`
- `developer`
- `maintainer`
- `owner`

Note: `access_level` is not supported for personal access tokens.

## Outputs

| Output | Description |
|--------|-------------|
| `tokens` | Full token objects (sensitive) |
| `token_values` | Map of token names to secret values (sensitive) |

## YAML Format

```yaml
token-name:
  scopes:
    - read_repository
    - write_repository
  access_level: developer      # optional, default: maintainer
  description: "Token description"  # optional
  expires_at: "2026-12-31"     # optional, format: YYYY-MM-DD
```

## Cleanup

```bash
tofu destroy
```

Note: Destroying tokens will invalidate them immediately. Any systems using these tokens will lose access.
