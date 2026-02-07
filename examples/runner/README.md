# Runner Module Example

This example demonstrates the GitLab user runner module which creates project, group, and instance-level runners.

## Features Tested

### Project Runners from YAML (`runners.yml`)

| Runner | Type | Tags | Description |
|--------|------|------|-------------|
| `yaml-docker-runner` | project_type | docker, yaml, linux | Docker runner defined in YAML |
| `yaml-k8s-runner` | project_type | kubernetes, k8s, deploy | Kubernetes runner for deployments |
| `yaml-general-runner` | project_type | general, ci | General purpose CI runner |

### Project Runners from HCL (`runner.tf`)

| Runner | Type | Tags | Description |
|--------|------|------|-------------|
| `docker-runner` | project_type | docker, linux, amd64 | Docker executor for CI/CD pipelines |
| `shell-runner` | project_type | shell, linux | Shell executor for local scripts |

### Group Runners from HCL (`runner.tf`)

| Runner | Type | Tags | Description |
|--------|------|------|-------------|
| `shared-group-runner` | group_type | shared, docker | Shared runner for all group projects |

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

- GitLab API token with `api` scope
- Maintainer or Owner access to target project/group
- Admin access for instance-level runners

## Module Features

The runner module supports:

- **Project runners** - Runners scoped to a specific project
- **Group runners** - Runners shared across all projects in a group
- **Instance runners** - Global runners available to all projects (requires admin)
- **YAML file loading** - External configuration via YAML files
- **Create-only mode** - Ignore attribute changes after initial creation

## Runner Types

| Type | Description | Required Field |
|------|-------------|----------------|
| `project_type` | Runner for a specific project | `project_id` |
| `group_type` | Runner shared across a group | `group_id` |
| `instance_type` | Global runner for all projects | None (requires admin) |

## Access Levels

| Level | Description |
|-------|-------------|
| `not_protected` | Runner can pick up jobs from any branch |
| `ref_protected` | Runner only picks up jobs from protected branches |

## Configuration Options

| Option | Type | Description |
|--------|------|-------------|
| `runner_type` | string | **Required.** Scope of the runner |
| `project_id` | number | Project ID (required for project_type) |
| `group_id` | number | Group ID (required for group_type) |
| `description` | string | Description of the runner |
| `tag_list` | set(string) | List of runner tags |
| `access_level` | string | Access level (not_protected, ref_protected) |
| `locked` | bool | Lock runner to current project |
| `paused` | bool | Pause runner from accepting jobs |
| `untagged` | bool | Handle jobs without tags |
| `maximum_timeout` | number | Max job timeout in seconds (min 600) |
| `maintenance_note` | string | Maintenance notes (max 1024 chars) |

## YAML Format

```yaml
runner-name:
  runner_type: project_type  # Required: project_type, group_type, instance_type
  project_id: 12345          # Required for project_type
  group_id: 67890            # Required for group_type
  description: "Runner description"
  tag_list:
    - docker
    - linux
  access_level: not_protected  # or ref_protected
  locked: false
  paused: false
  untagged: true
  maximum_timeout: 3600
  maintenance_note: "Notes about this runner"
```

## Outputs

The module outputs the created runner resources which include:

- `id` - The runner ID
- `token` - The runner authentication token (sensitive)
- `status` - The runner status

## Cleanup

```bash
tofu destroy
```

Note: Destroying runners will unregister them from GitLab. Any CI/CD jobs using these runners will no longer be able to use them.
