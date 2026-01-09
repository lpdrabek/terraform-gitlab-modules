# Variables Module Example

This example demonstrates all features of the `variables` module.

## What it tests

- **Project variables** - CI/CD variables on a project
- **Group variables** - Shared variables across all projects in a group
- **Masked variables** - Secrets hidden in job logs
- **Protected variables** - Variables only available in protected branches
- **Raw variables** - Variables without `$` expansion
- **File variables** - Variables exposed as files
- **Environment scopes** - Variables scoped to specific environments
- **YAML file loading** - Additional variables loaded from `variables.yml`

## Usage

```bash
export GITLAB_TOKEN="your-token"
tofu init
tofu plan
tofu apply
```

## Prerequisites

- Edit `main.tf` with your group path and project path
