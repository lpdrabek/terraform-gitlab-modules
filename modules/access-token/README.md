# GitLab Access Token Module

This Terraform module manages GitLab access tokens for projects, groups, and personal accounts. It supports defining tokens via Terraform configuration or YAML files, with comprehensive validation for scopes and expiration dates.

## Features

- Create and manage GitLab project, group, or personal access tokens
- YAML file support for easier token management
- Comprehensive scope validation per token type
- Required expiration date enforcement

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0

## Usage

### Basic Usage - Project Access Token

```hcl
module "project_token" {
  source = "./modules/access-token"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  access_tokens = {
    ci-deploy-token = {
      scopes       = ["read_repository", "write_repository"]
      access_level = "maintainer"
      expires_at   = "2025-12-31"
      description  = "Token for CI/CD deployments"
    }
  }
}
```

### Basic Usage - Group Access Token

```hcl
module "group_token" {
  source = "./modules/access-token"

  target = {
    type = "group"
    id   = gitlab_group.my_group.id
  }

  access_tokens = {
    registry-token = {
      scopes       = ["read_registry", "write_registry"]
      access_level = "developer"
      expires_at   = "2025-06-30"
      description  = "Token for container registry access"
    }
  }
}
```

### Basic Usage - Personal Access Token

```hcl
module "personal_token" {
  source = "./modules/access-token"

  target = {
    type = "personal"
    id   = data.gitlab_user.current.id
  }

  access_tokens = {
    api-token = {
      scopes     = ["api", "read_user"]
      expires_at = "2025-12-31"
      description = "Personal API access token"
    }
  }
}
```

### Using YAML File

```hcl
module "tokens" {
  source = "./modules/access-token"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  access_tokens_file = "./tokens.yml"
}
```

Example `tokens.yml`:

```yaml
ci-deploy-token:
  scopes:
    - read_repository
    - write_repository
  access_level: maintainer
  expires_at: "2025-12-31"
  description: "Token for CI/CD deployments"

registry-token:
  scopes:
    - read_registry
    - write_registry
  access_level: developer
  expires_at: "2025-06-30"
  description: "Token for container registry access"
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `target` | Target for access tokens (project, group, or personal) | `object({type = string, id = string})` | - | Yes |
| `access_tokens` | Map of access tokens to create (key is token name) | `map(object({...}))` | `{}` | No |
| `access_tokens_file` | Path to YAML file containing access tokens | `string` | `null` | No |

## Token Properties

| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `scopes` | list(string) | Yes | - | List of scopes for the token |
| `expires_at` | string | Yes | - | Expiration date in `YYYY-MM-DD` format |
| `access_level` | string | No | `maintainer` | Access level (not applicable for personal tokens) |
| `description` | string | No | `null` | Description of the token |
| `validate_past_expiration_date` | bool | No | `null` | Whether to validate past expiration dates |

## Access Levels

Valid access levels for project and group tokens:

| Level | Description |
|-------|-------------|
| `no one` | No access |
| `minimal` | Minimal access |
| `guest` | Guest access |
| `planner` | Planner access |
| `reporter` | Reporter access |
| `developer` | Developer access |
| `maintainer` | Maintainer access (default) |
| `owner` | Owner access |

## Valid Scopes

Scopes vary by token type. Using an invalid scope for a token type will result in a validation error.

### Personal Token Scopes

`api`, `read_user`, `read_api`, `read_repository`, `write_repository`, `read_registry`, `write_registry`, `read_virtual_registry`, `write_virtual_registry`, `sudo`, `admin_mode`, `create_runner`, `manage_runner`, `ai_features`, `k8s_proxy`, `self_rotate`, `read_service_ping`

### Group Token Scopes

`api`, `read_api`, `read_registry`, `write_registry`, `read_virtual_registry`, `write_virtual_registry`, `read_repository`, `write_repository`, `create_runner`, `manage_runner`, `ai_features`, `k8s_proxy`, `read_observability`, `write_observability`, `self_rotate`

### Project Token Scopes

`api`, `read_api`, `read_registry`, `write_registry`, `read_repository`, `write_repository`, `create_runner`, `manage_runner`, `ai_features`, `k8s_proxy`, `read_observability`, `write_observability`, `self_rotate`

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| `tokens` | Map of created access tokens with their attributes | Yes |
| `token_values` | Map of token names to their secret values | Yes |

## Notes

- **Expiration Required**: All access tokens must have an `expires_at` date specified.
- **Scope Validation**: The module validates that scopes are valid for the target token type.
- **Access Level**: The `access_level` property is only applicable for project and group tokens, not personal tokens.
- **Token Values**: Token values are only available immediately after creation and are marked as sensitive.

## GitLab Documentation

- [Project Access Tokens](https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html)
- [Group Access Tokens](https://docs.gitlab.com/ee/user/group/settings/group_access_tokens.html)
- [Personal Access Tokens](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)
