# GitLab Pipeline Schedule Module

This Terraform module manages GitLab pipeline schedules for projects. It supports defining schedules via Terraform configuration or YAML files, with optional schedule variables.

## Features

- Create and manage GitLab pipeline schedules
- YAML file support for easier schedule management
- Schedule variables for passing values to scheduled pipelines
- Automatic ownership management with `take_ownership`

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0

## Usage

### Basic Usage

```hcl
module "pipeline_schedules" {
  source  = "gitlab.com/gitlab-utl/pipeline-schedule/gitlab"
  version = "~> 1.1"

  project_id = gitlab_project.my_project.id

  schedules = {
    nightly_build = {
      cron        = "0 2 * * *"
      description = "Nightly build and test"
      ref         = "refs/heads/main"
      active      = true
    }
  }
}
```

### With Variables

```hcl
module "pipeline_schedules" {
  source  = "gitlab.com/gitlab-utl/pipeline-schedule/gitlab"
  version = "~> 1.1"

  project_id = gitlab_project.my_project.id

  schedules = {
    nightly_deploy = {
      cron           = "0 2 * * *"
      description    = "Nightly deployment to staging"
      ref            = "refs/heads/main"
      active         = true
      take_ownership = true
      variables = {
        DEPLOY_ENV = {
          value = "staging"
        }
        DEBUG = {
          value = "true"
        }
      }
    }
  }
}
```

### Using YAML File

```hcl
module "pipeline_schedules" {
  source  = "gitlab.com/gitlab-utl/pipeline-schedule/gitlab"
  version = "~> 1.1"

  project_id     = gitlab_project.my_project.id
  schedules_file = "./schedules.yml"
}
```

Example `schedules.yml`:

```yaml
---
nightly_build:
  cron: "0 2 * * *"
  description: "Nightly build and test"
  ref: "refs/heads/main"
  active: true
  cron_timezone: "UTC"
  take_ownership: true
  variables:
    DEPLOY_ENV:
      value: "staging"
    CONFIG_FILE:
      value: "/etc/app/config.json"
      variable_type: "file"

weekly_cleanup:
  cron: "0 4 * * 0"
  description: "Weekly cleanup job"
  ref: "refs/heads/main"
  active: true
  cron_timezone: "Europe/London"
```

### Combining YAML and Terraform Variables

Schedules defined in Terraform take precedence over YAML file schedules:

```hcl
module "pipeline_schedules" {
  source  = "gitlab.com/gitlab-utl/pipeline-schedule/gitlab"
  version = "~> 1.1"

  project_id     = gitlab_project.my_project.id
  schedules_file = "./schedules.yml"

  # Override or add schedules
  schedules = {
    override_schedule = {
      cron        = "0 6 * * *"
      description = "This overrides the YAML schedule"
      ref         = "refs/heads/main"
    }
  }
}
```

## Schedule Properties

| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `cron` | string | Yes | - | Cron expression (e.g., `0 2 * * *`) |
| `description` | string | Yes | - | Description of the schedule |
| `ref` | string | Yes | - | Full branch/tag reference (e.g., `refs/heads/main`) |
| `active` | bool | No | `null` | Whether the schedule is active |
| `cron_timezone` | string | No | `null` | Timezone for cron (e.g., `UTC`, `Europe/London`) |
| `take_ownership` | bool | No | `null` | Take ownership of the schedule (required for managing variables) |
| `variables` | map | No | `{}` | Map of variables for the schedule |

## Variable Properties

| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `value` | string | Yes | - | The value of the variable |
| `variable_type` | string | No | `env_var` | Type: `env_var` or `file` |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `project_id` | Project ID for the pipeline schedule | `string` | - | Yes |
| `schedules` | Map of pipeline schedules | `map(object({...}))` | `{}` | No |
| `schedules_file` | Path to YAML file containing schedules | `string` | `null` | No |

## Outputs

| Name | Description |
|------|-------------|
| `pipeline_schedules` | Map of created pipeline schedules |
| `pipeline_schedule_variables` | Map of created pipeline schedule variables |

## Important Notes

### Branch References

The `ref` must be the **full branch reference**, not just the branch name:

```hcl
# Correct
ref = "refs/heads/main"
ref = "refs/heads/develop"
ref = "refs/tags/v1.0.0"

# Incorrect - will cause issues
ref = "main"
ref = "develop"
```

### Take Ownership

When using schedule variables, you should set `take_ownership = true`. This ensures the Terraform user owns the schedule and can manage its variables. Without ownership, you may receive 403 errors when creating variables.

### Pipeline Variables vs Inputs

GitLab 18.1+ recommends using **pipeline inputs** instead of **pipeline variables** for improved security. Some GitLab instances may have pipeline variables disabled by default.

If you receive 403 errors when creating schedule variables:
1. Check project settings: Settings > CI/CD > Variables > "Minimum role to use pipeline variables"
2. Ensure pipeline variables are enabled for your role

The Terraform provider does not yet support pipeline schedule inputs. This module uses the `gitlab_pipeline_schedule_variable` resource.

### Cron Expressions

Common cron patterns:

| Expression | Description |
|------------|-------------|
| `0 2 * * *` | Daily at 2:00 AM |
| `0 */6 * * *` | Every 6 hours |
| `0 8 * * 1-5` | Weekdays at 8:00 AM |
| `0 0 * * 0` | Weekly on Sunday at midnight |
| `0 0 1 * *` | Monthly on the 1st at midnight |

## GitLab Documentation

- [Scheduled Pipelines](https://docs.gitlab.com/ee/ci/pipelines/schedules.html)
- [Pipeline Schedules API](https://docs.gitlab.com/ee/api/pipeline_schedules.html)
- [CI/CD Inputs](https://docs.gitlab.com/ee/ci/inputs/)
