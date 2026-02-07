# GitLab Runner Module

This Terraform module manages GitLab user runners for projects, groups, and instances. It supports defining runners via Terraform configuration or YAML files, with a create-only mode to prevent drift after initial creation.

## Features

- Create and manage GitLab runners at project, group, or instance level
- YAML file support for external runner configuration
- Merge YAML and HCL definitions for flexible management
- Create-only mode to ignore attribute changes after creation
- Input validation for runner types, access levels, and required fields

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.8.0, < 19.0.0

## Usage

### Basic Usage - Project Runner

```hcl
module "runners" {
  source = "gitlab.com/gitlab-utl/runner/gitlab"

  runners = {
    "docker-runner" = {
      runner_type  = "project_type"
      project_id   = gitlab_project.my_project.id
      description  = "Docker executor for CI/CD pipelines"
      tag_list     = ["docker", "linux"]
      access_level = "not_protected"
    }
  }
}
```

### Group Runner

```hcl
module "runners" {
  source = "gitlab.com/gitlab-utl/runner/gitlab"

  runners = {
    "shared-runner" = {
      runner_type      = "group_type"
      group_id         = gitlab_group.my_group.id
      description      = "Shared runner for all group projects"
      tag_list         = ["shared", "docker"]
      access_level     = "not_protected"
      untagged         = true
      maintenance_note = "Shared runner for the engineering group"
    }
  }
}
```

### Instance Runner

```hcl
module "runners" {
  source = "gitlab.com/gitlab-utl/runner/gitlab"

  runners = {
    "global-runner" = {
      runner_type      = "instance_type"
      description      = "Global instance runner"
      tag_list         = ["global", "docker"]
      access_level     = "not_protected"
      untagged         = true
      maintenance_note = "Global shared runner for all projects"
    }
  }
}
```

### Using YAML File

```hcl
module "runners" {
  source = "gitlab.com/gitlab-utl/runner/gitlab"

  runners_file = "./runners.yml"
}
```

Example `runners.yml`:

```yaml
docker-runner:
  runner_type: project_type
  project_id: 12345
  description: "Docker runner defined in YAML"
  tag_list:
    - docker
    - linux
  access_level: not_protected
  maximum_timeout: 3600

k8s-runner:
  runner_type: project_type
  project_id: 12345
  description: "Kubernetes runner for deployments"
  tag_list:
    - kubernetes
    - k8s
  access_level: ref_protected
  locked: true
```

### Merging YAML and HCL

YAML and HCL runner definitions are merged. HCL definitions take precedence over YAML when keys overlap.

```hcl
module "runners" {
  source = "gitlab.com/gitlab-utl/runner/gitlab"

  runners_file = "./runners.yml"

  runners = {
    "additional-runner" = {
      runner_type  = "project_type"
      project_id   = 12345
      description  = "Runner defined in HCL alongside YAML"
      tag_list     = ["extra"]
    }
  }
}
```

### Create-Only Mode

When `create_only` is set to `true`, runners are created but all subsequent attribute changes are ignored. This is useful when runners are managed externally after initial registration.

```hcl
module "runners" {
  source = "gitlab.com/gitlab-utl/runner/gitlab"

  create_only = true

  runners = {
    "immutable-runner" = {
      runner_type = "project_type"
      project_id  = 12345
      description = "Runner that won't be updated after creation"
      tag_list    = ["immutable"]
    }
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `runners` | Map of GitLab user runners to create | `map(object({...}))` | `{}` | No |
| `runners_file` | Path to YAML file containing runners | `string` | `null` | No |
| `create_only` | If true, ignore attribute changes after creation | `bool` | `false` | No |

## Runner Properties

| Property | Type | Default | Required | Description |
|----------|------|---------|----------|-------------|
| `runner_type` | string | - | Yes | Runner scope: `instance_type`, `group_type`, or `project_type` |
| `project_id` | number | `null` | For `project_type` | Project ID to associate the runner with |
| `group_id` | number | `null` | For `group_type` | Group ID to associate the runner with |
| `description` | string | `null` | No | Description of the runner |
| `tag_list` | set(string) | `null` | No | Tags for matching jobs to runners |
| `access_level` | string | `null` | No | `not_protected` or `ref_protected` |
| `locked` | bool | `null` | No | Lock runner to current project |
| `paused` | bool | `null` | No | Pause runner from accepting jobs |
| `untagged` | bool | `false` | No | Allow runner to pick up untagged jobs |
| `maximum_timeout` | number | `null` | No | Max job timeout in seconds (minimum 600) |
| `maintenance_note` | string | `null` | No | Free-form maintenance notes for the runner |

## Runner Types

| Type | Description | Required Field |
|------|-------------|----------------|
| `project_type` | Runner scoped to a specific project | `project_id` |
| `group_type` | Runner shared across all projects in a group | `group_id` |
| `instance_type` | Global runner available to all projects (requires admin) | None |

## Access Levels

| Level | Description |
|-------|-------------|
| `not_protected` | Runner can pick up jobs from any branch |
| `ref_protected` | Runner only picks up jobs from protected branches |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| `runners` | Map of created runners with their attributes | No |
| `runner_ids` | Map of runner names to their IDs | No |
| `runner_tokens` | Map of runner names to their authentication tokens | Yes |

## GitLab Documentation

- [Runners](https://docs.gitlab.com/ee/ci/runners/)
- [Runner API](https://docs.gitlab.com/ee/api/runners.html)
- [Terraform GitLab Provider - gitlab_user_runner](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/user_runner)
