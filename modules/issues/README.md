# GitLab Issues Module

This module manages GitLab project issues with automatic label creation and flexible configuration options.

## Features

- Create and manage GitLab project issues
- Automatic label creation with custom or random colors or with our without description
- Smart label merging (preserves non-null color/description values) so you can define label once and then just use the label name
- Support for both code-based and YAML file-based issue configuration
- Create-only mode for issues that shouldn't be updated after creation (Create via code, let the Gitlab GUI take care of the rest, or manage fully via terraform)

## Usage

### Basic Example

```hcl
module "project_issues" {
  source     = "./modules/issues"
  project_id = "12345"

  issues = {
    bug_fix_authentication = {
      title       = "Fix authentication timeout"
      description = "Users are experiencing timeout errors during login"
      labels = {
        bug           = { color = "#FF0000", description = "Bug reports" }
        priority_high = { color = "#FFA500" }
        backend       = {}  # Random color will be generated
      }
      assignee_ids = [123, 456]
      milestone_id = 10
      due_date     = "2026-02-01"
      weight       = 5
    }

    feature_dark_mode = {
      title       = "Implement dark mode"
      description = "Add dark mode support to the application"
      labels = {
        feature       = { color = "#00FF00" }
        frontend      = {}
        priority_high = {}  # Will reuse color from bug_fix_authentication
      }
      issue_type = "issue"
      state      = "opened"
    }
  }
}
```

### Using YAML File

**issues.yml:**
```yaml
security_audit:
  title: "Quarterly security audit"
  description: "Perform security audit of all endpoints"
  labels:
    security:
      color: "#FF6B6B"
      description: "Security-related issues"
    compliance:
      color: "#4ECDC4"
  due_date: "2026-03-15"
  weight: 8
  confidential: true

documentation_update:
  title: "Update API documentation"
  description: "Update docs to reflect new endpoints"
  labels:
    documentation:
      color: "#95E1D3"
    backend: {}
  assignee_ids: [789]
```

**main.tf:**
```hcl
module "project_issues" {
  source     = "./modules/issues"
  project_id = "12345"

  issues_file = "./issues.yml"
}
```

### Create-Only Mode

Use this mode when you want to create issues but not update them after creation:

```hcl
module "project_issues" {
  source     = "./modules/issues"
  project_id = "12345"

  issues = {
    initial_setup = {
      title = "Project setup tasks"
      labels = {
        setup = { color = "#3498DB" }
      }
    }
  }

  create_only = true  # Issues won't be updated by Terraform after creation, which means for example if somebody closes an issue via Gitlab GUI, this code won't re-open it
}
```

## Label Behavior

### Smart Label Merging

When the same label appears in multiple issues with different attributes, the module intelligently merges them:

```hcl
issues = {
  issue1 = {
    title = "First issue"
    labels = {
      priority_high = { color = "#FF0000", description = "High priority" }
      bug = {}
    }
  }
  issue2 = {
    title = "Second issue"
    labels = {
      priority_high = {}  # Will use color & description from issue1
      bug = { color = "#FFA500" }
    }
  }
}
```

**Result:**
- `priority_high` → color: `#FF0000`, description: `"High priority"` (from issue1)
- `bug` → color: `#FFA500` (from issue2)

### Random Color Generation

Labels without a specified color get a random 6-character hex color:

```hcl
labels = {
  my_label = {}  # Will get random color like #A3C2F1
}
```

## Variables

### Required Variables

| Name | Type | Description |
|------|------|-------------|
| `project_id` | `string` | ID of the GitLab project |

`
> **NOTE**: Either `issues` or `issues_file` are required, but listed below as "Optional" because they do have default values to allow choosing between them
`

### Optional Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `issues` | `map(object)` | `{}` | Map of issues to create (see schema below) |
| `issues_file` | `string` | `null` | Path to YAML file containing issues |
| `create_only` | `bool` | `false` | If true, ignore changes after creation |

### Issue Object Schema

```hcl
{
  title        = string                    # Required
  description  = optional(string)
  assignee_ids = optional(set(number))
  labels = optional(map(object({
    color       = optional(string)         # 6-digit hex: AABBCC or #AABBCC
    description = optional(string)
  })))

  # Issue metadata
  issue_type   = optional(string)          # issue, incident, test_case
  state        = optional(string)          # opened, closed
  confidential = optional(bool)
  weight       = optional(number)          # >= 0

  # Dates
  due_date     = optional(string)          # YYYY-MM-DD
  created_at   = optional(string)          # ISO 8601 (requires admin/owner)
  updated_at   = optional(string)          # ISO 8601

  # References
  milestone_id  = optional(number)
  epic_issue_id = optional(number)

  # Discussion
  discussion_locked     = optional(bool)
  discussion_to_resolve = optional(string)

  # Merge request resolution
  merge_request_to_resolve_discussions_of = optional(number)

  # Lifecycle
  delete_on_destroy = optional(bool)
}
```

## Validation Rules

The module validates:

- `issue_type` must be: `issue`, `incident`, or `test_case`
- `state` must be: `opened` or `closed`
- `weight` must be a non-negative integer (≥ 0)
- `due_date` must be in `YYYY-MM-DD` format
- `description` must not exceed 1,048,576 characters

## Examples

### Incident with High Priority

```hcl
issues = {
  production_outage = {
    title        = "Production database outage"
    description  = "Database server is unresponsive"
    issue_type   = "incident"
    confidential = true
    labels = {
      incident      = { color = "#FF0000" }
      priority_critical = { color = "#8B0000" }
      infrastructure = {}
    }
    assignee_ids = [100, 101]
    weight       = 10
  }
}
```

### Test Case with Dependencies

```hcl
issues = {
  e2e_auth_test = {
    title       = "E2E authentication flow test"
    issue_type  = "test_case"
    labels = {
      testing = { color = "#9B59B6" }
      qa      = {}
    }
    milestone_id = 5
    due_date     = "2026-01-31"
  }
}
```

### Combining Code and File

```hcl
module "project_issues" {
  source     = "./modules/issues"
  project_id = "12345"

  # Issues from code
  issues = {
    urgent_bug = {
      title = "Critical bug in production"
      labels = {
        bug = { color = "#FF0000" }
      }
    }
  }

  # Additional issues from file
  issues_file = "${path.module}/planned-issues.yml"
}
```

## How It Works

1. **Merge Issues**: Combines issues from `issues` variable and `issues_file`
2. **Extract Labels**: Collects all unique labels from all issues
3. **Smart Merge**: Merges label definitions, preferring non-null values
4. **Create Labels**: Uses the `labels` module to create all labels
5. **Create Issues**: Creates issues with references to the created labels

## Outputs

| Name | Description |
|------|-------------|
| `issues` | Map of created issues with their attributes |
| `issue_iids` | Map of issue keys to their issue IDs (iid - the project-specific issue number) |
| `issue_web_urls` | Map of issue keys to their web URLs |
| `milestones` | Map of milestones used by issues (either created or fetched from existing) |

## Dependencies

This module depends on:
- [GitLab Provider](https://registry.terraform.io/providers/gitlabhq/gitlab/latest) >= 18.0.0
- Internal `labels` module for label creation

## Notes

- Labels are created before issues to ensure references are valid
- When using `create_only = true`, most attributes are ignored after initial creation
- Label colors can be specified with or without the `#` prefix
- The module handles both file-based and code-based configurations simultaneously

## License

See main project LICENSE file.
