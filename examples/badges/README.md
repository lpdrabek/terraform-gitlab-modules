# Badges Module Example

This example demonstrates all features of the `badges` module.

## What it tests

- **Project badges** - Pipeline and coverage badges on a project
- **Group badges** - A website badge on a group
- **YAML file loading** - Additional badge loaded from `badges.yml`

## Usage

```bash
export GITLAB_TOKEN="your-token"
tofu init
tofu plan
tofu apply
```

## Prerequisites

- Edit `main.tf` with your group path and project path
