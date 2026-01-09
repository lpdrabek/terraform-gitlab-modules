# Project Module Example

This example demonstrates the GitLab project module which creates multiple projects with various configurations including milestones, labels, badges, and issues.

## Features Tested

### From HCL (`project.tf`)

| Project | Features |
|---------|----------|
| `tf-test-basic` | Minimal project with just description and README |
| `tf-test-full` | CI/CD, MR settings, milestones, labels, badges, issues |
| `tf-test-container-policy` | Container registry expiration policy |
| `tf-test-archived` | Archived project with archive_on_destroy |
| `tf-test-strict-mr` | Strict MR requirements, custom commit templates |

### From YAML (`projects.yml`)

| Project | Features |
|---------|----------|
| `tf-test-yaml-basic` | Basic YAML-defined project |
| `tf-test-yaml-full` | Full config with milestones, labels, badges, issues |
| `tf-test-yaml-minimal` | Minimal YAML definition |

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

- GitLab Free tier for basic features
- GitLab Premium/Ultimate for:
  - Push rules
  - Some access level configurations

## Module Features

The project module supports:

- **Multiple projects** via map variable or YAML file
- **All gitlab_project attributes** (60+ configurable options)
- **Inline milestones** per project with date validation
- **Inline labels** per project with color and description
- **Inline badges** per project (pipeline status, coverage, etc.)
- **Inline issues** per project with label/milestone references
- **YAML file loading** for external configuration
- **create_only mode** to prevent drift on external changes

## Integrated Sub-modules

Each project can include:

| Feature | Description |
|---------|-------------|
| `milestones` | Project milestones with dates and state |
| `labels` | Scoped labels (e.g., `priority::high`) |
| `badges` | Pipeline, coverage, and custom badges |
| `issues` | Issues with labels and milestone assignments |

## Cleanup

```bash
tofu destroy
```

Note: Projects with `archive_on_destroy = true` will be archived instead of deleted.
