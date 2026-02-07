# Application Module Example

This example demonstrates all features of the `application` module.

## What it tests

- **Confidential applications** - Server-side apps where secrets can be kept secure
- **Non-confidential applications** - SPAs and mobile apps
- **OIDC applications** - Using GitLab as an OpenID Connect provider
- **OAuth applications** - Using GitLab as an OAuth 2.0 provider
- **Various scopes** - Different permission levels for different use cases
- **YAML file loading** - Applications loaded from `applications.yml`

## Usage

```bash
export TF_VAR_gitlab_token="your-admin-token"
tofu init
tofu plan
tofu apply
```

## Prerequisites

- **Admin access required** - GitLab applications are instance-level resources
- Edit `main.tf` with your GitLab instance URL if not using gitlab.com
- Update redirect URLs in `application.tf` and `applications.yml` to match your services

## Notes

- The `application_credentials` output contains sensitive data (client secrets)
- Use `tofu output -json application_credentials` to retrieve secrets for configuring OAuth clients
- Application secrets are only available on initial creation, not after import
