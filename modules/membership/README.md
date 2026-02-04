# GitLab Membership Module

This Terraform module manages GitLab project and group memberships. It supports defining members via Terraform configuration or YAML files, with flexible user lookups by email, username, or user ID.

## Features

- Add members to GitLab projects or groups
- YAML file support for easier membership management
- User lookup by email, username, or user ID
- Configurable access levels and expiration dates
- Support for custom member roles

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0

## Usage

### Basic Usage - Project Membership

```hcl
module "project_membership" {
  source = "./modules/membership"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  membership = {
    maintainer = {
      users      = ["admin@example.com", "lead@example.com"]
      find_users = "email"
    }
    developer = {
      users      = ["dev1@example.com", "dev2@example.com"]
      find_users = "email"
    }
  }
}
```

### Basic Usage - Group Membership

```hcl
module "group_membership" {
  source = "./modules/membership"

  target = {
    type = "group"
    id   = gitlab_group.my_group.id
  }

  membership = {
    owner = {
      users      = ["admin_user"]
      find_users = "username"
    }
    developer = {
      users      = ["dev_user1", "dev_user2"]
      find_users = "username"
    }
  }
}
```

### Using YAML File

```hcl
module "membership" {
  source = "./modules/membership"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  membership_file = "./membership.yml"
}
```

Example `membership.yml`:

```yaml
maintainer:
  users:
    - admin@example.com
    - lead@example.com
  find_users: email

developer:
  users:
    - dev1@example.com
    - dev2@example.com
  find_users: email
  expires_at: "2025-12-31"

guest:
  users:
    - guest_user
  find_users: username
```

### With Expiration Date

```hcl
module "membership" {
  source = "./modules/membership"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  membership = {
    developer = {
      users      = ["contractor@example.com"]
      find_users = "email"
      expires_at = "2025-06-30"
    }
  }
}
```

### Using User IDs

```hcl
module "membership" {
  source = "./modules/membership"

  target = {
    type = "project"
    id   = gitlab_project.my_project.id
  }

  membership = {
    developer = {
      users      = ["12345", "67890"]
      find_users = "userid"
    }
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `target` | Target for membership (project or group) | `object({type = string, id = string})` | - | Yes |
| `membership` | Map of access levels to membership configurations | `map(object({...}))` | `{}` | No |
| `membership_file` | Path to YAML file containing membership configuration | `string` | `null` | No |

## Membership Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `users` | list(string) | - | List of users (emails, usernames, or user IDs based on `find_users`) |
| `find_users` | string | `"email"` | How to look up users: `email`, `username`, or `userid` |
| `expires_at` | string | `null` | Membership expiration date in `YYYY-MM-DD` format |
| `member_role_id` | number | `null` | Custom member role ID |
| `skip_subresources_on_destroy` | bool | `null` | Skip subresources when removing membership |
| `unassign_issuables_on_destroy` | bool | `null` | Unassign issues/MRs when removing membership |

## Access Levels

The map key defines the access level. Valid access levels are:

| Level | Value | Description |
|-------|-------|-------------|
| `guest` | 10 | Guest access |
| `reporter` | 20 | Reporter access |
| `developer` | 30 | Developer access |
| `maintainer` | 40 | Maintainer access |
| `owner` | 50 | Owner access (groups only) |

## Outputs

| Name | Description |
|------|-------------|
| `memberships` | Map of created memberships with their details |
| `user_ids` | Map of membership keys to resolved user IDs (useful when looking up by email/username) |

## GitLab Documentation

- [Project Members](https://docs.gitlab.com/ee/user/project/members/)
- [Group Members](https://docs.gitlab.com/ee/user/group/#add-users-to-a-group)
- [Project Members API](https://docs.gitlab.com/ee/api/members.html)
