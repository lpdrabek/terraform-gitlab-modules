# GitLab Badges Module

This Terraform module manages GitLab badges for projects and groups. It supports defining badges via Terraform configuration or YAML files.

## Features

- Create and manage badges for GitLab projects or groups
- YAML file support for easier badge management
- URL validation for badge links and images
- Create-only mode to prevent drift after initial creation

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0

## Usage

### Basic Usage - Project Badges

```hcl
module "project_badges" {
  source  = "gitlab.com/gitlab-utl/badges/gitlab"
  version = "~> 1.1"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  badges = {
    pipeline = {
      link_url  = "https://gitlab.com/my-group/my-project/-/pipelines"
      image_url = "https://gitlab.com/my-group/my-project/badges/main/pipeline.svg"
    }
    coverage = {
      link_url  = "https://gitlab.com/my-group/my-project/-/commits/main"
      image_url = "https://gitlab.com/my-group/my-project/badges/main/coverage.svg"
    }
  }
}
```

### Basic Usage - Group Badges

```hcl
module "group_badges" {
  source  = "gitlab.com/gitlab-utl/badges/gitlab"
  version = "~> 1.1"

  target = {
    type = "group"
    id   = gitlab_group.my_group.id
  }

  badges = {
    documentation = {
      link_url  = "https://docs.example.com"
      image_url = "https://img.shields.io/badge/docs-online-green.svg"
    }
  }
}
```

### Using YAML File

```hcl
module "badges" {
  source  = "gitlab.com/gitlab-utl/badges/gitlab"
  version = "~> 1.1"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  badges_file = "./badges.yml"
}
```

Example `badges.yml`:

```yaml
pipeline:
  link_url: "https://gitlab.com/my-group/my-project/-/pipelines"
  image_url: "https://gitlab.com/my-group/my-project/badges/main/pipeline.svg"

coverage:
  link_url: "https://gitlab.com/my-group/my-project/-/commits/main"
  image_url: "https://gitlab.com/my-group/my-project/badges/main/coverage.svg"

license:
  link_url: "https://opensource.org/licenses/MIT"
  image_url: "https://img.shields.io/badge/license-MIT-blue.svg"
```

### Create-Only Mode

```hcl
module "badges" {
  source  = "gitlab.com/gitlab-utl/badges/gitlab"
  version = "~> 1.1"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  create_only = true

  badges = {
    pipeline = {
      link_url  = "https://gitlab.com/my-group/my-project/-/pipelines"
      image_url = "https://gitlab.com/my-group/my-project/badges/main/pipeline.svg"
    }
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `target` | Target for badges (project or group) | `object({type = string, id = string})` | - | Yes |
| `badges` | Map of badges to create | `map(object({link_url = string, image_url = string}))` | `{}` | No |
| `badges_file` | Path to YAML file containing badges | `string` | `null` | No |
| `create_only` | If true, ignore attribute changes after creation | `bool` | `false` | No |

## Badge Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `link_url` | string | Yes | URL to link when badge is clicked (must be http:// or https://) |
| `image_url` | string | Yes | URL of the badge image (must be http:// or https:// and end with .svg, .png, .jpg, .jpeg, or .gif) |

## Validations

The module includes the following validations:

1. **URL Scheme**: Both `link_url` and `image_url` must use `http://` or `https://`
2. **Image Format**: `image_url` must point to a valid image file (svg, png, jpg, jpeg, or gif)

## Outputs

| Name | Description |
|------|-------------|
| `badges` | Map of created badges with their details |

## GitLab Documentation

- [Badges](https://docs.gitlab.com/ee/user/project/badges.html)
- [Badges API](https://docs.gitlab.com/ee/api/project_badges.html)
