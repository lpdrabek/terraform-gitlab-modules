# GitLab Variables Module

This Terraform module manages GitLab CI/CD variables for both projects and groups. It supports defining variables via Terraform configuration or YAML files, with comprehensive validation to prevent common configuration errors.

## Features

- Create and manage GitLab project or group CI/CD variables
- YAML file support for easier variable management
- Comprehensive validations for GitLab requirements

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0

## Usage

### Basic Usage - Project Variables

```hcl
module "project_variables" {
  source  = "gitlab.com/gitlab-utl/variables/gitlab"
  version = "~> 1.1"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  variables = {
    DATABASE_URL = {
      value             = "postgresql://localhost:5432/mydb"
      description       = "Database connection string"
      masked            = true
      protected         = true
      environment_scope = "production"
    }

    API_KEY = {
      value       = "super-secret-key-12345"
      description = "Third-party API key"
      masked      = true
      hidden      = true
    }
  }
}
```

### Basic Usage - Group Variables

```hcl
module "group_variables" {
  source  = "gitlab.com/gitlab-utl/variables/gitlab"
  version = "~> 1.1"

  target = {
    type = "group"
    id   = gitlab_group.my_group.id
  }

  variables = {
    DOCKER_REGISTRY = {
      value       = "registry.gitlab.com/mygroup"
      description = "Docker registry URL"
    }
  }
}
```

### Using YAML File

```hcl
module "variables" {
  source  = "gitlab.com/gitlab-utl/variables/gitlab"
  version = "~> 1.1"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  variables_file = "./variables.yml"
}
```

Example `variables.yml`:

```yaml
---
DATABASE_URL:
  value: "postgresql://user:password@localhost:5432/mydb"
  description: "Database connection string"
  masked: true
  protected: true
  environment_scope: "production"

API_KEY:
  value: "super-secret-api-key-12345"
  description: "Third-party API key"
  masked: true
  hidden: true
  environment_scope: "*"

SSH_PRIVATE_KEY:
  value: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQ...
    -----END OPENSSH PRIVATE KEY-----
  description: "SSH private key for deployments"
  variable_type: "file"
  protected: true

CONFIG_JSON:
  value: |
    {
      "env": "production",
      "debug": false
    }
  description: "Application configuration"
  variable_type: "file"
```

### Combining YAML and Terraform Variables

Variables defined in Terraform take precedence over YAML file variables:

```hcl
module "variables" {
  source  = "gitlab.com/gitlab-utl/variables/gitlab"
  version = "~> 1.1"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  variables_file = "./variables.yml"

  # Override or add variables
  variables = {
    OVERRIDE_VAR = {
      value = "this overrides the YAML value"
    }
  }
}
```

## Variable Properties

| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `value` | string | Yes | - | The value of the variable |
| `description` | string | No | `null` | Description of the variable |
| `environment_scope` | string | No | `null` | Environment scope for the variable (e.g., `production`, `staging/*`, `*`) |
| `hidden` | bool | No | `false` | If true, the variable is hidden in the UI |
| `masked` | bool | No | `false` | If true, the value is masked in job logs |
| `protected` | bool | No | `false` | If true, the variable is only available for protected branches/tags |
| `raw` | bool | No | `false` | If true, the variable value is not expanded |
| `variable_type` | string | No | `env_var` | Type of variable: `env_var` or `file` |

## Validations

The module includes the following validations to prevent configuration errors:

### 1. Variable Type Validation

Ensures `variable_type` is either `env_var` or `file`:

```hcl
# Valid
variable_type = "env_var"
variable_type = "file"

# Invalid - will fail validation
variable_type = "invalid"
```

### 2. Masked Variable Length

GitLab requires masked variables to be at least 8 characters:

```hcl
# Valid
masked = true
value  = "secret123"  # 9 characters

# Invalid - will fail validation
masked = true
value  = "secret"     # 6 characters - too short
```

### 3. Masked vs Raw Conflict

A variable cannot be both masked and raw:

```hcl
# Valid
masked = true
raw    = false

# Invalid - will fail validation
masked = true
raw    = true  # Cannot be both masked and raw
```

### 4. Environment Scope Format

Environment scope must contain only valid characters:

```hcl
# Valid
environment_scope = "production"
environment_scope = "staging/*"
environment_scope = "*"
environment_scope = "review/feature-123"

# Invalid - will fail validation
environment_scope = "prod!@#"  # Invalid characters
```

## Common Use Cases

### Masked Database Credentials

```hcl
variables = {
  DB_PASSWORD = {
    value             = "super-secret-password-123"
    description       = "Database password"
    masked            = true
    protected         = true
    environment_scope = "production"
  }
}
```

### SSH Key as File Variable

```hcl
variables = {
  SSH_DEPLOY_KEY = {
    value = file("${path.module}/deploy-key.pem")
    description    = "SSH key for deployments"
    variable_type  = "file"
    protected      = true
    masked         = false  # Files cannot be masked
  }
}
```

### Environment-Specific Variables

```hcl
variables = {
  API_ENDPOINT_PROD = {
    value             = "https://api.example.com"
    environment_scope = "production"
  }

  API_ENDPOINT_STAGING = {
    value             = "https://api.staging.example.com"
    environment_scope = "staging/*"
  }
}
```

### Raw Variables (No Variable Expansion)

```hcl
variables = {
  CUSTOM_SCRIPT = {
    value = "echo $CI_COMMIT_SHA"  # Will not expand $CI_COMMIT_SHA
    raw   = true
    description = "Custom script with literal dollar signs"
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `target` | Target for variables (project or group) with type and id | `object({type = string, id = string})` | - | Yes |
| `variables` | Map of variables to create | `map(object({...}))` | `{}` | No |
| `variables_file` | Path to YAML file containing variables | `string` | `null` | No |


## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| `project_variables` | Map of created project variables | Yes |
| `group_variables` | Map of created group variables | Yes |
| `variables` | Map of all created variables (project or group depending on target) | Yes |
| `variable_keys` | List of created variable keys (names) | No |
| `variable_metadata` | Map of variable keys to their non-sensitive metadata (environment_scope, variable_type, protected, masked, hidden, raw) | No |

## Notes

- **Masked Variables**: Must be at least 8 characters long. GitLab will fail to create shorter masked variables.
- **File Variables**: The `variable_type = "file"` creates a temporary file in the CI/CD job with the variable content.
- **Raw Variables**: Cannot be masked. Raw variables are not expanded, useful for scripts with `$` characters.
- **Environment Scope**: Use `*` to match all environments, or specific patterns like `production` or `staging/*`.
- **Hidden Variables**: Hidden variables are not visible in the GitLab UI but are still available in CI/CD jobs.

## GitLab Documentation

- [CI/CD Variables](https://docs.gitlab.com/ee/ci/variables/)
- [Masked Variables](https://docs.gitlab.com/ee/ci/variables/#mask-a-cicd-variable)
- [Protected Variables](https://docs.gitlab.com/ee/ci/variables/#protect-a-cicd-variable)
- [File Variables](https://docs.gitlab.com/ee/ci/variables/#use-file-type-cicd-variables)
