# Deploy Token Module Example

This example demonstrates the GitLab deploy token module which creates project and group deploy tokens with scope validation.

## Features Tested

### Project Tokens from YAML (`tokens.yml`)

| Token | Scopes | Username |
|-------|--------|----------|
| `package-reader` | read_package_registry | pkg-reader |
| `registry-full-access` | read_registry, write_registry | registry-bot |
| `repository-clone` | read_repository | clone-bot |

### Project Tokens from HCL (`deploy_token.tf`)

| Token | Scopes | Username |
|-------|--------|----------|
| `ci-deploy` | read_repository, read_registry | ci-deploy-user |
| `registry-push` | read_registry, write_registry | registry-pusher |

### Group Tokens from HCL (`deploy_token.tf`)

| Token | Scopes | Username |
|-------|--------|----------|
| `group-registry-read` | read_registry | group-registry-reader |

### Create-Only Mode (`deploy_token.tf`)

| Token | Scopes | Username |
|-------|--------|----------|
| `immutable-deploy-token` | read_repository | immutable-deployer |

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

The deploy token module supports:

- **Project deploy tokens** via `gitlab_project_deploy_token`
- **Group deploy tokens** via `gitlab_group_deploy_token`
- **YAML file loading** for external configuration
- **Scope validation** with clear error messages
- **Create-only mode** to prevent drift after initial creation

## Valid Scopes

| Scope | Description |
|-------|-------------|
| `read_repository` | Read access to repository |
| `read_registry` | Read access to container registry |
| `write_registry` | Write access to container registry |
| `read_virtual_registry` | Read access to virtual registry |
| `write_virtual_registry` | Write access to virtual registry |
| `read_package_registry` | Read access to package registry |
| `write_package_registry` | Write access to package registry |

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
    - read_registry
  username: custom-username       # optional, default: gitlab+deploy-token-{n}
  expires_at: "2026-12-31T23:59:59Z"  # optional, RFC3339 format
```

## Cleanup

```bash
tofu destroy
```

Note: Destroying tokens will invalidate them immediately. Any systems using these tokens will lose access.
