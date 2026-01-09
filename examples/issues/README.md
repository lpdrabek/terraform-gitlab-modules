# Issues Module Example

This example demonstrates all features of the `issues` module.

## What it tests

- **Issue creation** - Multiple issues with various attributes
- **Label reuse** - Define a label once with full details, reference by name (`{}`) in other issues
- **Milestone reuse** - Define a milestone once with full details, reference by name (`{}`) in other issues
- **Issue types** - Regular issues and incidents
- **Issue attributes** - due_date, confidential, description
- **Deduplication** - Labels and milestones are created once, shared across issues
- **YAML file loading** - Additional issues loaded from `issues.yml`

## Reuse Pattern

```hcl
# First issue: define with full details
"Issue A" = {
  labels = {
    bug = {
      color       = "#FF0000"
      description = "Something isn't working"
    }
  }
  milestone = {
    "v1.0.0" = {
      description = "Initial release"
      due_date    = "2025-03-31"
    }
  }
}

# Second issue: reference by name only
"Issue B" = {
  labels = {
    bug = {}  # Reuses color and description from Issue A
  }
  milestone = {
    "v1.0.0" = {}  # Reuses description and dates from Issue A
  }
}
```

## Usage

```bash
export GITLAB_TOKEN="your-token"
tofu init
tofu plan
tofu apply
```

## Prerequisites

- Edit `main.tf` with your group path and project path
