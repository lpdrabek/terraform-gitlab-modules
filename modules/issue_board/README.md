# GitLab Issue Board Module

This Terraform module manages GitLab issue boards for projects and groups. It supports defining issue boards via Terraform configuration or YAML files.

## Features

- Create and manage issue boards for GitLab projects or groups
- YAML file support for easier board management
- Configurable board lists with labels, assignees, and milestones
- Support for both project and group issue boards

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0

> **Note:** Some features like `assignee_id`, `weight`, and `iteration_id` require GitLab Premium/Ultimate.

## Usage

### Basic Usage - Project Issue Board

```hcl
module "project_boards" {
  source = "./modules/issue_board"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  boards = {
    "Development Board" = {
      labels = ["development"]
    }
    "Sprint Board" = {
      milestone_id = gitlab_project_milestone.current_sprint.id
    }
  }
}
```

### Basic Usage - Group Issue Board

```hcl
module "group_boards" {
  source = "./modules/issue_board"

  target = {
    type = "group"
    id   = gitlab_group.my_group.id
  }

  boards = {
    "Team Board" = {
      labels = ["team-a"]
    }
  }
}
```

### With Board Lists

```hcl
module "boards" {
  source = "./modules/issue_board"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  boards = {
    "Kanban Board" = {
      lists = [
        {
          label_id = gitlab_project_label.todo.id
        },
        {
          label_id = gitlab_project_label.in_progress.id
        },
        {
          label_id = gitlab_project_label.done.id
        }
      ]
    }
  }
}
```

### Using YAML File

```hcl
module "boards" {
  source = "./modules/issue_board"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  boards_file = "./boards.yml"
}
```

Example `boards.yml`:

```yaml
Development Board:
  labels:
    - development
    - backend

Sprint Board:
  milestone_id: 123
  lists:
    - label_id: 456
    - label_id: 789

Bug Triage:
  labels:
    - bug
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `target` | Target for issue boards (project or group) | `object({type = string, id = string})` | - | Yes |
| `boards` | Map of issue boards to create | `map(object({...}))` | `{}` | No |
| `boards_file` | Path to YAML file containing issue boards | `string` | `null` | No |

## Board Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `labels` | set(string) | `null` | Labels to scope the board |
| `assignee_id` | number | `null` | Assignee to scope the board (Premium/Ultimate, project only) |
| `milestone_id` | number | `null` | Milestone to scope the board |
| `weight` | number | `null` | Weight to scope the board (Premium/Ultimate, project only) |
| `lists` | list(object) | `null` | Board lists configuration |

## List Properties

### Project Board Lists

| Property | Type | Description |
|----------|------|-------------|
| `label_id` | number | Label ID for the list |
| `assignee_id` | number | Assignee ID for the list (Premium/Ultimate) |
| `milestone_id` | number | Milestone ID for the list (Premium/Ultimate) |
| `iteration_id` | number | Iteration ID for the list (Premium/Ultimate) |

### Group Board Lists

| Property | Type | Description |
|----------|------|-------------|
| `label_id` | number | Label ID for the list |
| `position` | number | Position of the list |

## Outputs

| Name | Description |
|------|-------------|
| `project_boards` | Map of created project issue boards |
| `group_boards` | Map of created group issue boards |

## GitLab Documentation

- [Issue Boards](https://docs.gitlab.com/ee/user/project/issue_board.html)
- [Project Issue Boards API](https://docs.gitlab.com/ee/api/boards.html)
- [Group Issue Boards API](https://docs.gitlab.com/ee/api/group_boards.html)
