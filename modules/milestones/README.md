# GitLab Milestones Module

This module manages GitLab project milestones with flexible configuration options.

## Features

- Create and manage GitLab project milestones
- Support for both code-based and YAML file-based milestone configuration
- Create-only mode for milestones that shouldn't be updated after creation (so they can be managed through Gitlab GUI)
- Comprehensive input validation
- Map key is used as milestone title for clean configuration

## Usage

### Basic Example

```hcl
module "project_milestones" {
  source  = "gitlab.com/gitlab-utl/milestones/gitlab"
  version = "~> 1.1"
  project_id = "12345"

  milestones = {
    v1_0_release = {
      description = "Version 1.0 Release"
      state       = "active"
      start_date  = "2026-01-01"
      due_date    = "2026-03-31"
    }

    q1_2026 = {
      description = "Q1 2026 Goals"
      start_date  = "2026-01-01"
      due_date    = "2026-03-31"
    }

    beta_release = {
      description = "Beta milestone"
      state       = "closed"
    }
  }
}
```

### Using YAML File

**milestones.yml:**
```yaml
v2_0_release:
  description: "Version 2.0 Release"
  state: "active"
  start_date: "2026-04-01"
  due_date: "2026-06-30"

q2_2026:
  description: "Q2 2026 Goals"
  start_date: "2026-04-01"
  due_date: "2026-06-30"

legacy_milestone:
  description: "Completed legacy milestone"
  state: "closed"
```

**main.tf:**
```hcl
module "project_milestones" {
  source  = "gitlab.com/gitlab-utl/milestones/gitlab"
  version = "~> 1.1"
  project_id = "12345"

  milestones_file = "${path.module}/milestones.yml"
}
```

### Combining Code and YAML

```hcl
module "project_milestones" {
  source  = "gitlab.com/gitlab-utl/milestones/gitlab"
  version = "~> 1.1"
  project_id = "12345"

  # Milestones from code
  milestones = {
    urgent_release = {
      description = "Urgent hotfix release"
      due_date    = "2026-01-15"
      state       = "active"
    }
  }

  # Additional milestones from file
  milestones_file = "${path.module}/planned-milestones.yml"
}
```

### Create-Only Mode

Use this mode when you want to create milestones but not update them after creation:

```hcl
module "project_milestones" {
  source  = "gitlab.com/gitlab-utl/milestones/gitlab"
  version = "~> 1.1"
  project_id = "12345"

  milestones = {
    initial_planning = {
      description = "Initial project planning phase"
      due_date    = "2026-02-01"
    }
  }

  create_only = true  # Milestones won't be updated by Terraform after creation
}
```

## Variables

### Required Variables

| Name | Type | Description |
|------|------|-------------|
| `project_id` | `string` | ID of the GitLab project |

### Optional Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `milestones` | `map(object)` | `{}` | Map of milestones to create (see schema below) |
| `milestones_file` | `string` | `null` | Path to YAML file containing milestones |
| `create_only` | `bool` | `false` | If true, ignore changes after creation |

### Milestone Object Schema

**Important:** The map key is used as the milestone `title`.

```hcl
{
  description = optional(string)
  state       = optional(string)    # Valid values: "active", "closed"
  start_date  = optional(string)    # Format: YYYY-MM-DD
  due_date    = optional(string)    # Format: YYYY-MM-DD
}
```

## Validation Rules

The module validates:

- `state` must be: `active` or `closed`
- `start_date` must be in `YYYY-MM-DD` format
- `due_date` must be in `YYYY-MM-DD` format
- `start_date` must be before or equal to `due_date`
- Empty strings are allowed and treated as `null`

## Examples

### Simple Milestone

```hcl
milestones = {
  mvp_launch = {
    description = "Minimum Viable Product Launch"
    due_date    = "2026-03-01"
  }
}
```

### Milestone with Date Range

```hcl
milestones = {
  sprint_1 = {
    description = "First sprint"
    state       = "active"
    start_date  = "2026-01-01"
    due_date    = "2026-01-15"
  }
}
```

### Closed Milestone

```hcl
milestones = {
  alpha_release = {
    description = "Alpha version completed"
    state       = "closed"
    due_date    = "2025-12-31"
  }
}
```

### Minimal Configuration

```hcl
milestones = {
  planning = {}  # Just a title, no other attributes
}
```

## YAML File Format

The YAML file uses the same structure as the Terraform configuration:

```yaml
# Basic milestone
milestone_name:
  description: "Milestone description"
  due_date: "2026-03-31"

# Milestone with full details
detailed_milestone:
  description: "Detailed milestone"
  state: "active"
  start_date: "2026-01-01"
  due_date: "2026-03-31"

# Minimal milestone
minimal: {}
```

## How It Works

1. **Load Milestones**: Reads milestones from `milestones` variable and optionally from `milestones_file`
2. **Merge Data**: Combines milestones from both sources
3. **Normalize**: Converts empty strings to `null` values
4. **Validate**: Validates all milestone attributes
5. **Create Resources**: Creates GitLab milestones using map keys as titles

## Empty String Handling

Empty strings are automatically converted to `null`:

```hcl
milestones = {
  example = {
    description = "Test"
    start_date  = ""  # Treated as null
  }
}
```

## Outputs

| Name | Description |
|------|-------------|
| `milestones` | Map of created milestones with their attributes |
| `milestone_ids` | Map of milestone titles to their IDs |
| `milestone_iids` | Map of milestone titles to their project-specific IIDs |

## Notes

- Map keys are used as milestone titles (e.g., `v1_0_release` becomes the title)
- When using `create_only = true`, changes to title, description, dates, and state are ignored after initial creation
- Milestones from code and YAML file are merged together
- YAML file milestones take precedence if the same key exists in both sources

## Dependencies

This module requires:
- [GitLab Provider](https://registry.terraform.io/providers/gitlabhq/gitlab/latest) >= 18.0.0

## License

See main project LICENSE file.
