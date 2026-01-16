# Group Module Example

This example demonstrates the GitLab group module which manages GitLab groups with various configuration options.

## Features Tested

This example demonstrates:

- **YAML-based groups** - Loading group configuration from `groups.yml`
- **Inline groups** - Defining groups directly in Terraform
- **Nested subgroups** - Creating groups with `parent_id`
- **Push rules** - Enforcing commit message and branch naming conventions
- **Security settings** - 2FA, membership lock, share restrictions
- **Create-only mode** - Ignoring changes after initial creation
- **Groups with projects** - Creating projects inside groups

### Groups from YAML (`groups.yml`)

| Group | Features |
|-------|----------|
| `my-organization` | Basic group with access control |
| `secure-team` | Branch protection defaults |
| `compliant-team` | Push rules for commit compliance |
| `restricted-access` | High security settings (2FA, locks) |

### Groups with Projects

| Group | Projects |
|-------|----------|
| `platform-team` | infrastructure, shared-libraries, documentation |
| `my-organization/backend` | api-service, worker-service |

## Usage

```bash
# Set your GitLab token
export TF_VAR_gitlab_token="your-token-here"

# Optional: Use a different GitLab instance
export TF_VAR_gitlab_base_url="https://gitlab.example.com"

# Initialize and apply
tofu init
tofu plan
tofu apply
```

## Requirements

- GitLab API token with `api` scope
- Permissions to create groups (or admin access for top-level groups)

## Important: GitLab.com Limitation

On GitLab.com, you cannot create top-level groups via the API. Top-level groups must be created manually in the GitLab UI, then imported into your Terraform state:

```bash
# Import an existing top-level group
tofu import 'module.groups_yaml.gitlab_group.groups["my-organization"]' my-organization
```

After importing, you can manage the group using Terraform. Subgroups (groups with a `parent_id`) can be created directly without this limitation.

For self-managed GitLab instances, this limitation may not apply depending on your configuration.

## Module Features

The group module supports:

- **Core settings** - name, path, description, visibility, parent group
- **Access control** - project/subgroup creation levels, membership lock
- **Branch protection defaults** - default protection for new branches
- **Push rules** - commit message regex, branch naming, secret prevention
- **Security** - 2FA requirement, IP restrictions, email domain restrictions
- **Runner settings** - shared runners configuration
- **YAML file loading** for external configuration
- **Create-only mode** to prevent drift after initial creation

## Group Properties

### Core Settings

| Property | Description |
|----------|-------------|
| `path` | Group URL path (defaults to name) |
| `description` | Group description |
| `parent_id` | Parent group ID for nested groups |
| `visibility_level` | `private`, `internal`, or `public` |

### Access Control

| Property | Description |
|----------|-------------|
| `project_creation_level` | Who can create projects: `noone`, `owner`, `maintainer`, `developer` |
| `subgroup_creation_level` | Who can create subgroups: `owner`, `maintainer` |
| `membership_lock` | Prevent adding members to projects |
| `share_with_group_lock` | Prevent sharing projects with other groups |
| `request_access_enabled` | Allow access requests |
| `prevent_forking_outside_group` | Prevent forking to external namespaces |

### Security

| Property | Description |
|----------|-------------|
| `require_two_factor_authentication` | Require 2FA for all members |
| `two_factor_grace_period` | Hours before 2FA is enforced |
| `ip_restriction_ranges` | Allowed IP ranges (top-level groups only) |
| `allowed_email_domains_list` | Allowed email domains for members |

## YAML Format

```yaml
my-group:
  description: "My group description"
  visibility_level: private
  project_creation_level: maintainer
  subgroup_creation_level: maintainer

  # Optional: Push rules
  push_rules:
    commit_message_regex: "^(feat|fix):"
    prevent_secrets: true

  # Optional: Security
  require_two_factor_authentication: true
```

## Nested Groups

To create nested groups, use `parent_id`:

```hcl
module "parent" {
  source = "../../modules/group"
  groups = {
    "parent-group" = {
      description = "Parent group"
    }
  }
}

module "children" {
  source = "../../modules/group"
  groups = {
    "child-group" = {
      description = "Child group"
      parent_id   = module.parent.group_ids["parent-group"]
    }
  }
}
```

## Groups with Projects

Define projects directly inside the group - no need for separate module calls:

```hcl
module "my_team" {
  source = "../../modules/group"

  groups = {
    "platform-team" = {
      description             = "Platform engineering team"
      visibility_level        = "private"
      project_creation_level  = "maintainer"

      # Projects created inside this group automatically
      projects = {
        "infrastructure" = {
          description            = "Infrastructure as Code repository"
          initialize_with_readme = true
          default_branch         = "main"
        }
        "shared-libraries" = {
          description            = "Shared libraries and utilities"
          initialize_with_readme = true
          topics                 = ["library", "shared"]
        }
      }
    }
  }
}
```

This creates:
```
platform-team/
├── infrastructure
└── shared-libraries
```

The `namespace_id` is automatically set to the parent group's ID - you don't need to specify it.

### Project Options

Projects support these settings:

| Property | Description |
|----------|-------------|
| `description` | Project description |
| `visibility_level` | `private`, `internal`, or `public` |
| `default_branch` | Default branch name |
| `initialize_with_readme` | Create initial README |
| `topics` | Project topics/tags |
| `merge_method` | `merge`, `rebase_merge`, or `ff` |
| `squash_option` | Squash commit settings |
| `builds_access_level` | CI/CD access: `enabled`, `disabled` |
| `push_rules` | Commit/branch naming rules |
| `labels` | Project labels with color and description |
| `milestones` | Project milestones with dates |
| `badges` | Project badges (link_url, image_url) |
| `issues` | Project issues with labels and milestones |

### Full Example with Labels, Milestones, Badges, Issues

```yaml
# In groups.yml
my-team:
  description: "My team"

  projects:
    api-service:
      description: "API service"
      initialize_with_readme: true

      labels:
        bug:
          color: "#FF0000"
          description: "Bug reports"
        feature:
          color: "#00FF00"

      milestones:
        v1.0:
          description: "First release"
          due_date: "2024-06-01"

      badges:
        pipeline:
          link_url: "https://gitlab.com/..."
          image_url: "https://gitlab.com/.../badge.svg"

      issues:
        setup-project:
          title: "Initial project setup"
          description: "Configure CI/CD and project settings"
```

## Cleanup

```bash
tofu destroy
```

Note: Destroying groups will delete all projects and subgroups within them.
