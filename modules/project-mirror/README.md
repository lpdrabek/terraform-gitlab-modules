# GitLab Project Mirror Module

This Terraform module manages GitLab project mirroring (push and pull mirrors). It supports defining mirror configuration via Terraform variables or YAML files.

## Features

- Configure push mirrors to replicate a GitLab project to external repositories
- Configure pull mirrors to sync from external repositories into GitLab
- YAML file support for easier configuration management
- Support for password and SSH public key authentication (push mirrors)
- Branch filtering with regex patterns (Premium/Ultimate)

## Requirements

- Terraform >= 1.6.0
- GitLab Provider >= 18.0.0, < 19.0.0

## Usage

### Push Mirror with Password Authentication

```hcl
module "push_mirror" {
  source = "./modules/project-mirror"

  type = "push"

  target = {
    "my-group/my-project" = {
      url                     = "https://github.com/example/mirror-repo.git"
      auth_method             = "password"
      enabled                 = true
      only_protected_branches = true
    }
  }
}
```

### Push Mirror with SSH Authentication

```hcl
module "push_mirror_ssh" {
  source = "./modules/project-mirror"

  type = "push"

  target = {
    "my-group/my-project" = {
      url                 = "ssh://git@github.com/example/mirror-repo.git"
      auth_method         = "ssh_public_key"
      enabled             = true
      keep_divergent_refs = true
    }
  }
}
```

### Pull Mirror

```hcl
module "pull_mirror" {
  source = "./modules/project-mirror"

  type = "pull"

  target = {
    "my-group/my-project" = {
      url                                 = "https://github.com/example/source-repo.git"
      auth_user                           = "oauth2"
      auth_password                       = var.github_token
      enabled                             = true
      mirror_overwrites_diverged_branches = true
      mirror_trigger_builds               = true
    }
  }
}
```

### Using YAML File

```hcl
module "mirrors" {
  source = "./modules/project-mirror"

  type        = "push"
  target_file = "./mirrors.yml"
}
```

Example `mirrors.yml`:

```yaml
# Push mirror configuration
# Key is the project ID or path

my-group/project-1:
  url: https://github.com/example/project-1-mirror.git
  auth_method: password
  enabled: true
  only_protected_branches: true

my-group/project-2:
  url: ssh://git@github.com/example/project-2-mirror.git
  auth_method: ssh_public_key
  keep_divergent_refs: true
```

### Branch Filtering (Premium/Ultimate)

```hcl
module "push_mirror_filtered" {
  source = "./modules/project-mirror"

  type = "push"

  target = {
    "my-group/my-project" = {
      url                 = "https://github.com/example/mirror-repo.git"
      auth_method         = "password"
      mirror_branch_regex = "^(main|release-.*)$"
    }
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `type` | Type of mirror: `push` or `pull` | `string` | - | Yes |
| `target` | Map of project mirrors to configure | `map(object({...}))` | `{}` | No |
| `target_file` | Path to YAML file containing mirror configuration | `string` | `null` | No |

## Target Properties

### Common Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `url` | string | - | URL of the remote repository (required) |
| `enabled` | bool | `true` | Whether the mirror is enabled |
| `mirror_branch_regex` | string | `null` | Regex for branches to mirror (Premium/Ultimate) |

### Push Mirror Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `auth_method` | string | `null` | Authentication method: `ssh_public_key` or `password` |
| `keep_divergent_refs` | bool | `null` | Skip divergent refs instead of failing |
| `only_protected_branches` | bool | `null` | Only mirror protected branches |

### Pull Mirror Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `auth_user` | string | `null` | Username for authentication |
| `auth_password` | string | `null` | Password or token for authentication |
| `mirror_overwrites_diverged_branches` | bool | `null` | Overwrite diverged branches |
| `mirror_trigger_builds` | bool | `null` | Trigger pipelines when mirror updates |
| `only_mirror_protected_branches` | bool | `null` | Only mirror protected branches |

## Outputs

| Name | Description |
|------|-------------|
| `push_mirrors` | Map of created push mirrors with their details |
| `pull_mirrors` | Map of created pull mirrors with their details |
| `mirrored_projects` | List of project IDs/paths that have mirrors configured |
| `mirror_keys` | SSH public keys for push mirrors using ssh_public_key authentication |

## GitLab Tier Requirements

### Free Tier
- Basic push and pull mirror functionality
- Password authentication

### Premium/Ultimate Only
- `mirror_branch_regex` - Branch filtering with regex patterns

## GitLab Documentation

- [Repository Mirroring](https://docs.gitlab.com/ee/user/project/repository/mirror/)
- [Push Mirroring](https://docs.gitlab.com/ee/user/project/repository/mirror/push.html)
- [Pull Mirroring](https://docs.gitlab.com/ee/user/project/repository/mirror/pull.html)
