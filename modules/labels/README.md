# GitLab Labels Module

This Terraform module manages GitLab labels for projects and groups. It supports defining labels via Terraform configuration or YAML files.

## Features

- Create and manage labels for GitLab projects or groups
- YAML file support for easier label management
- Create-only mode to prevent drift after initial creation

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0

## Usage

### Basic Usage - Project Labels

```hcl
module "project_labels" {
  source = "./modules/labels"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  labels = {
    bug = {
      color       = "#FF0000"
      description = "Something isn't working"
    }
    enhancement = {
      color       = "#00FF00"
      description = "New feature or request"
    }
    documentation = {
      color       = "#0000FF"
      description = "Improvements or additions to documentation"
    }
  }
}
```

### Basic Usage - Group Labels

```hcl
module "group_labels" {
  source = "./modules/labels"

  target = {
    type = "group"
    id   = gitlab_group.my_group.id
  }

  labels = {
    priority-high = {
      color       = "#FF0000"
      description = "High priority issue"
    }
    priority-low = {
      color       = "#00FF00"
      description = "Low priority issue"
    }
  }
}
```

### Using YAML File

```hcl
module "labels" {
  source = "./modules/labels"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  labels_file = "./labels.yml"
}
```

Example `labels.yml`:

```yaml
bug:
  color: "#FF0000"
  description: "Something isn't working"

enhancement:
  color: "#00FF00"
  description: "New feature or request"

documentation:
  color: "#0000FF"
  description: "Improvements or additions to documentation"

help-wanted:
  color: "#FFFF00"
  description: "Extra attention is needed"

wontfix:
  color: "#CCCCCC"
  description: "This will not be worked on"
```

### Create-Only Mode

```hcl
module "labels" {
  source = "./modules/labels"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  create_only = true

  labels = {
    bug = {
      color       = "#FF0000"
      description = "Something isn't working"
    }
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `target` | Target for labels (project or group) | `object({type = string, id = string})` | - | Yes |
| `labels` | Map of labels to create | `map(object({color = optional(string), description = optional(string)}))` | `{}` | No |
| `labels_file` | Path to YAML file containing labels | `string` | `null` | No |
| `create_only` | If true, ignore attribute changes after creation | `bool` | `false` | No |

## Label Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `color` | string | No | Hex color code for the label (e.g., `#FF0000`) |
| `description` | string | No | Description of the label |

## Outputs

| Name | Description |
|------|-------------|
| `labels` | Map of created labels with their details |

## GitLab Documentation

- [Labels](https://docs.gitlab.com/ee/user/project/labels.html)
- [Labels API](https://docs.gitlab.com/ee/api/labels.html)
- [Group Labels API](https://docs.gitlab.com/ee/api/group_labels.html)
