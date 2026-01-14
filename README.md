# GitLab Terraform Modules

A collection of reusable Terraform/OpenTofu modules for managing GitLab resources. These modules provide a consistent, declarative way to manage GitLab projects, groups, and their associated resources.

## Requirements

- Terraform >= 1.6.0 or OpenTofu >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0
- GitLab API token with appropriate scopes

## AI use in the project

AI has been used to create all the things I don't like creating so:

 * Documentation - all the READMEs, including this one, but not this section
 * Entirety of [examples](./examples/) - a way to test the code before pushing
 * The issues, labels and milestones that are assigned to this project (using my own modules to manage them from different repository)
 * In the future - probably [CONTRIBUTING.md](./CONTRIBUTING.md) when needed

 **All other code has NOT been touched by AI. I enjoy writing code and I'm taking this as an opportunity to get to know the Gitlab ecosystem too.**

## Available Modules

| Module | Description |
|--------|-------------|
| [project](./modules/project/) | Create and manage GitLab projects with full configuration |
| [branch-protection](./modules/branch-protection/) | Manage branch protection rules |
| [tag-protection](./modules/tag-protection/) | Manage tag protection rules |
| [membership](./modules/membership/) | Manage project and group memberships |
| [labels](./modules/labels/) | Manage project and group labels |
| [badges](./modules/badges/) | Manage project and group badges |
| [milestones](./modules/milestones/) | Manage project milestones |
| [issues](./modules/issues/) | Manage project issues |
| [issue_board](./modules/issue_board/) | Manage project and group issue boards |
| [variables](./modules/variables/) | Manage CI/CD variables |

## Quick Start

### 1. Configure the GitLab Provider

```hcl
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 18.0.0, < 19.0.0"
    }
  }
}

provider "gitlab" {
  base_url = "https://gitlab.com"  # Or your self-hosted GitLab URL
  token    = var.gitlab_token
}

variable "gitlab_token" {
  description = "GitLab API token"
  type        = string
  sensitive   = true
}
```

### 2. Use a Module

```hcl
module "my_project" {
  source = "path/to/modules/project"

  projects = {
    "awesome-project" = {
      description      = "My awesome project"
      namespace_id     = 12345
      visibility_level = "private"
      default_branch   = "main"
    }
  }
}
```

### 3. Apply

```bash
export TF_VAR_gitlab_token="your-token-here"
tofu init
tofu plan
tofu apply
```

## Common Features

All modules share these common features:

### YAML File Support

Define resources in YAML files for easier management:

```hcl
module "labels" {
  source = "./modules/labels"

  target = {
    type = "project"
    id   = "12345"
  }

  labels_file = "./labels.yml"
}
```

### Create-Only Mode

Prevent Terraform from managing resources after initial creation:

```hcl
module "project" {
  source = "./modules/project"

  create_only = true

  projects = {
    "imported-project" = {
      description = "Don't manage after creation"
    }
  }
}
```

### Flexible Lookups

User lookups by email, username, or user ID:

```hcl
module "membership" {
  source = "./modules/membership"

  target = {
    type = "project"
    id   = "12345"
  }

  membership = {
    developer = {
      users      = ["user@example.com"]
      find_users = "email"  # or "username" or "userid"
    }
  }
}
```

## Examples

Working examples are available in the [examples](./examples/) directory:

| Example | Description |
|---------|-------------|
| [project](./examples/project/) | Project creation with various settings |
| [branch-protection](./examples/branch-protection/) | Branch protection rules |
| [tag-protection](./examples/tag-protection/) | Tag protection rules |
| [membership](./examples/membership/) | Project and group memberships |
| [labels](./examples/labels/) | Label management |
| [badges](./examples/badges/) | Badge management |
| [milestones](./examples/milestones/) | Milestone management |
| [issues](./examples/issues/) | Issue management |
| [issue_board](./examples/issue_board/) | Issue board management |
| [variables](./examples/variables/) | CI/CD variable management |

## GitLab Tier Compatibility

Most features work with GitLab Free tier. Premium/Ultimate features are documented in each module's README.

| Feature | Free | Premium | Ultimate |
|---------|:----:|:-------:|:--------:|
| Basic branch protection | ✓ | ✓ | ✓ |
| User/group-level branch permissions | | ✓ | ✓ |
| Basic tag protection | ✓ | ✓ | ✓ |
| User/group-level tag permissions | | ✓ | ✓ |
| Code owner approval | | ✓ | ✓ |
| Custom member roles | | | ✓ |
| Issue board assignee/iteration lists | | ✓ | ✓ |

## Authentication

Set your GitLab token via environment variable:

```bash
export TF_VAR_gitlab_token="glpat-xxxxxxxxxxxx"
```

Or use a `.tfvars` file (not recommended for sensitive data):

```hcl
# terraform.tfvars
gitlab_token = "glpat-xxxxxxxxxxxx"
```

### Required Token Scopes

| Scope | Required For |
|-------|--------------|
| `api` | All operations |
| `read_api` | Read-only operations |

## Contributing

1. Create a feature branch
2. Make your changes
3. Test with `tofu validate` and `tofu plan`
4. Submit a merge request

## License

See [LICENSE](./LICENSE) for details.
