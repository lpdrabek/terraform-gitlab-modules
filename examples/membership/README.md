# Membership Module Example

This example demonstrates the GitLab membership module which manages project and group memberships with flexible user lookup options.

## Features Tested

### Project Membership from YAML (`membership.yml`)

| Access Level | Users | Lookup Method |
|--------------|-------|---------------|
| `developer` | developer1@example.com, developer2@example.com | email |
| `reporter` | reporter_user | username |

### Project Membership from HCL (`membership.tf`)

| Access Level | Users | Lookup Method | Expires |
|--------------|-------|---------------|---------|
| `developer` | harthu | username | 2026-12-31 |

### Group Membership from HCL (`membership.tf`)

| Access Level | Users | Lookup Method |
|--------------|-------|---------------|
| `developer` | harthu | username |

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
- Owner or Maintainer access to target project/group
- Users must exist in GitLab before adding as members

## Module Features

The membership module supports:

- **Project membership** via `gitlab_project_membership`
- **Group membership** via `gitlab_group_membership`
- **YAML file loading** for external configuration
- **Flexible user lookup** by email, username, or user ID
- **Expiration dates** for temporary access
- **Custom member roles** via `member_role_id` (GitLab Ultimate)

## User Lookup Methods

| Method | Description | Example |
|--------|-------------|---------|
| `email` | Look up user by email address | `user@example.com` |
| `username` | Look up user by GitLab username | `johndoe` |
| `userid` | Use GitLab user ID directly | `12345` |

## Valid Access Levels

Use access level as the map key:

| Access Level | Description |
|--------------|-------------|
| `guest` | Read-only access to issues and wiki |
| `reporter` | Read access to code, issues, merge requests |
| `developer` | Push to non-protected branches, create MRs |
| `maintainer` | Push to protected branches, manage settings |
| `owner` | Full control (groups only) |

## YAML Format

```yaml
# Key is the access level
developer:
  users:
    - "user1@example.com"
    - "user2@example.com"
  find_users: email           # email, username, or userid
  expires_at: "2026-12-31"    # optional, format: YYYY-MM-DD

maintainer:
  users:
    - "admin_username"
  find_users: username
```

## Additional Options

| Option | Description | Applies To |
|--------|-------------|------------|
| `expires_at` | Membership expiration date (YYYY-MM-DD) | project, group |
| `member_role_id` | Custom member role ID (Ultimate) | project, group |
| `skip_subresources_on_destroy` | Skip subresource cleanup on destroy | group only |
| `unassign_issuables_on_destroy` | Unassign issues/MRs on destroy | group only |

## Cleanup

```bash
tofu destroy
```

Note: Destroying memberships will immediately revoke access for the affected users.
