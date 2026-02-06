# Project Mirror Module Example

This example demonstrates the `project-mirror` module for configuring push and pull mirrors.

## What it tests

- **Push mirror with password authentication** - Mirror a project to a remote repository using HTTPS
- **Push mirror with SSH authentication** - Mirror using SSH public key, outputs the generated SSH key
- **YAML file loading** - Example configuration via `mirrors.yml`

## Commented-out examples

The `project-mirror.tf` file includes commented-out examples for:

- Push mirror with branch regex filtering (Premium/Ultimate)
- Pull mirror with authentication
- Pull mirror with protected branches only
- Multiple push mirrors in a single module call

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

## Prerequisites

- GitLab API token with `api` scope
- Maintainer access to the target project
- Edit `main.tf` with your project path
- For SSH mirrors: add the output SSH public key to the target repository after creation
