# Milestones Module Example

This example demonstrates all features of the `milestones` module.

## What it tests

- **Project milestones** - Version milestones with dates
- **State management** - Active and default states
- **Date ranges** - Start and due dates
- **Minimal milestones** - Backlog with no dates
- **Create-only mode** - Milestones that ignore updates after creation
- **YAML file loading** - Additional milestones loaded from `milestones.yml`

## Usage

```bash
export GITLAB_TOKEN="your-token"
tofu init
tofu plan
tofu apply
```

## Prerequisites

- Edit `main.tf` with your group path and project path
