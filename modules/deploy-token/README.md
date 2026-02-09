# GitLab Deploy Token Module

This Terraform module manages GitLab deploy tokens for projects and groups. It supports defining tokens via Terraform configuration or YAML files, with comprehensive validation for scopes.

## Features

- Create and manage GitLab project and group deploy tokens
- YAML file support for easier token management
- Comprehensive scope validation
- `create_only` mode to prevent drift after initial creation

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.8.0, < 19.0.0

## Usage

### Basic Usage - Project Deploy Token

```hcl
module "project_deploy_token" {
  source  = "gitlab.com/gitlab-utl/deploy-token/gitlab"
  version = "~> 1.0"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  tokens = {
    ci-deploy-token = {
      scopes   = ["read_repository", "read_registry"]
      username = "deploy-user"
    }
  }
}
```

### Basic Usage - Group Deploy Token

```hcl
module "group_deploy_token" {
  source  = "gitlab.com/gitlab-utl/deploy-token/gitlab"
  version = "~> 1.0"

  target = {
    type = "group"
    id   = gitlab_group.my_group.id
  }

  tokens = {
    registry-token = {
      scopes     = ["read_registry", "write_registry"]
      expires_at = "2025-12-31T23:59:59Z"
    }
  }
}
```

### Using YAML File

```hcl
module "deploy_tokens" {
  source  = "gitlab.com/gitlab-utl/deploy-token/gitlab"
  version = "~> 1.0"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  tokens_file = "./deploy-tokens.yml"
}
```

Example `deploy-tokens.yml`:

```yaml
ci-deploy-token:
  scopes:
    - read_repository
    - read_registry
  username: deploy-user

registry-push-token:
  scopes:
    - read_registry
    - write_registry
  expires_at: "2025-12-31T23:59:59Z"
```

### Create-Only Mode

Use `create_only = true` when you want to create tokens but ignore any subsequent changes to their configuration:

```hcl
module "deploy_tokens" {
  source  = "gitlab.com/gitlab-utl/deploy-token/gitlab"
  version = "~> 1.0"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  create_only = true

  tokens = {
    immutable-token = {
      scopes = ["read_repository"]
    }
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `target` | Target for deploy tokens (project or group) | `object({type = string, id = string})` | - | Yes |
| `tokens` | Map of deploy tokens to create (key is token name) | `map(object({...}))` | `{}` | No |
| `tokens_file` | Path to YAML file containing deploy tokens | `string` | `null` | No |
| `create_only` | If true, ignore attribute changes after creation | `bool` | `false` | No |

## Token Properties

| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `scopes` | list(string) | Yes | - | List of scopes for the token |
| `username` | string | No | `gitlab+deploy-token-{n}` | Custom username for the token |
| `expires_at` | string | No | Never expires | Expiration date in RFC3339 format (e.g., `2025-12-31T23:59:59Z`) |
| `validate_past_expiration_date` | bool | No | `null` | Whether to validate past expiration dates |

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

| Name | Description | Sensitive |
|------|-------------|-----------|
| `tokens` | Map of created deploy tokens with their attributes | Yes |
| `token_values` | Map of token names to their secret values | Yes |

## Notes

- **Token Values**: Token values are only available immediately after creation and are marked as sensitive. They cannot be retrieved for imported resources.
- **Expiration**: Deploy tokens do not expire by default. Set `expires_at` if you need an expiration date.
- **Scope Validation**: The module validates that all scopes are valid deploy token scopes.

## GitLab Documentation

- [Deploy Tokens](https://docs.gitlab.com/ee/user/project/deploy_tokens/)
- [Group Deploy Tokens](https://docs.gitlab.com/ee/user/project/deploy_tokens/index.html#group-deploy-tokens)
