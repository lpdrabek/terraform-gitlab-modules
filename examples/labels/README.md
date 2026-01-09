# Labels Module Example

This example demonstrates all features of the `labels` module.

## What it tests

- **Project labels** - Labels with explicit colors and auto-generated colors
- **Group labels** - Team ownership labels on a group
- **YAML file loading** - Additional labels loaded from `labels.yml`

## Usage

```bash
export GITLAB_TOKEN="your-token"
tofu init
tofu plan
tofu apply
```

## Prerequisites

- Edit `main.tf` with your group path and project path
