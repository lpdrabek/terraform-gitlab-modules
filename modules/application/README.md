# GitLab Application Module

This Terraform module manages GitLab OAuth applications. It supports defining applications via Terraform configuration or YAML files.

## Features

- Create and manage GitLab OAuth applications
- YAML file support for easier application management
- Secure handling of application secrets

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0
- Admin access to GitLab instance (applications are instance-level resources)

## Usage

### Basic Usage

```hcl
module "applications" {
  source = "./modules/application"

  applications = {
    "my-oauth-app" = {
      redirect_url = "https://myapp.example.com/callback"
      scopes       = ["api", "read_user", "openid"]
      confidential = true
    }
  }
}
```

### Non-Confidential Application (Mobile)

```hcl
module "applications" {
  source = "./modules/application"

  applications = {
    "public" = {
      redirect_url = "https://app1.example.com/auth/callback"
      scopes       = ["read_api", "openid", "profile", "email"]
      confidential = false  
    }
  }
}
```

### Using YAML File

```hcl
module "applications" {
  source = "./modules/application"

  applications_file = "./applications.yml"
}
```

Example `applications.yml`:

```yaml
---
grafana:
  redirect_url: "https://grafana.example.com/login/gitlab"
  scopes:
    - api
    - read_user
    - openid
    - profile
    - email
  confidential: true

argocd:
  redirect_url: "https://argocd.example.com/api/dex/callback"
  scopes:
    - read_api
    - openid
  confidential: true

public-dashboard:
  redirect_url: "https://dashboard.example.com/oauth/callback"
  scopes:
    - read_api
    - openid
    - profile
  confidential: false
```

### Combining YAML and Terraform

Applications defined in Terraform take precedence over YAML file applications:

```hcl
module "applications" {
  source = "./modules/application"

  applications_file = "./applications.yml"

  # Override or add applications
  applications = {
    "override-app" = {
      redirect_url = "https://override.example.com/callback"
      scopes       = ["api"]
    }
  }
}
```

## Application Properties

| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `redirect_url` | string | Yes | - | The URL GitLab redirects to after authentication |
| `scopes` | set(string) | Yes | - | OAuth scopes for the application |
| `confidential` | bool | No | `true` | Whether the client secret can be kept confidential |

## Available Scopes

| Scope | Description |
|-------|-------------|
| `api` | Full API access |
| `read_api` | Read-only API access |
| `read_user` | Read user information |
| `read_repository` | Read repository contents |
| `write_repository` | Write repository contents |
| `read_registry` | Read container registry |
| `write_registry` | Write container registry |
| `sudo` | Sudo access (admin) |
| `admin_mode` | Admin mode access |
| `openid` | OpenID Connect authentication |
| `profile` | User profile information |
| `email` | User email address |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `applications` | Map of applications to create | `map(object({...}))` | `{}` | No |
| `applications_file` | Path to YAML file containing applications | `string` | `null` | No |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| `applications` | Map of created applications with their attributes | No |
| `application_ids` | Map of application names to their IDs | No |
| `application_credentials` | Map of application names to their credentials (application_id and secret) | Yes |

## Notes

- **Admin Access Required**: GitLab applications are instance-level resources and require admin access to create.
- **Confidential Applications**: Set `confidential = true` (default) for server-side applications where the secret can be kept secure. Set `confidential = false` for Single Page Apps or mobile applications.
- **Secret Handling**: The application secret is only available when creating a new application. It cannot be retrieved after import.
- **Scopes**: Use `openid` scope if you plan to use the application for OIDC authentication.

## Common Use Cases

### GitLab as OIDC Provider for Grafana

```hcl
applications = {
  "grafana" = {
    redirect_url = "https://grafana.example.com/login/gitlab"
    scopes       = ["api", "read_user", "openid", "profile", "email"]
    confidential = true
  }
}
```

### GitLab as OIDC Provider for ArgoCD

```hcl
applications = {
  "argocd" = {
    redirect_url = "https://argocd.example.com/api/dex/callback"
    scopes       = ["read_api", "openid", "profile", "email"]
    confidential = true
  }
}
```

### GitLab as OAuth Provider for CI/CD Tool

```hcl
applications = {
  "jenkins" = {
    redirect_url = "https://jenkins.example.com/securityRealm/finishLogin"
    scopes       = ["read_user", "api"]
    confidential = true
  }
}
```

## GitLab Documentation

- [OAuth 2.0 Applications](https://docs.gitlab.com/ee/integration/oauth_provider.html)
- [OpenID Connect Provider](https://docs.gitlab.com/ee/integration/openid_connect_provider.html)
- [OAuth 2.0 Scopes](https://docs.gitlab.com/ee/integration/oauth_provider.html#view-all-authorized-applications)
