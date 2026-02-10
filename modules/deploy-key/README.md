# Deploy Key Module

Manages GitLab project deploy keys. Supports creating new deploy keys (`gitlab_deploy_key`) and enabling them on additional projects (`gitlab_deploy_key_enable`).

## Usage

### Create deploy keys

```hcl
module "deploy_keys" {
  source = "../../modules/deploy-key"

  project = "my-group/my-project"

  deploy_keys = {
    "ci-read-only" = {
      key = "ssh-ed25519 AAAAC3..."
    }
    "ci-push" = {
      key      = "ssh-ed25519 AAAAC3..."
      can_push = true
    }
  }
}
```

### Create a key and enable it on additional projects

```hcl
module "shared_key" {
  source = "../../modules/deploy-key"

  project = "my-group/project-a"

  deploy_keys = {
    "ci-key" = {
      key    = "ssh-ed25519 AAAAC3..."
      enable = ["my-group/project-b", "my-group/project-c"]
    }
  }
}
```

### Enable an existing key on multiple projects

```hcl
module "enable_key" {
  source = "../../modules/deploy-key"

  project = "my-group/project-a"

  deploy_keys = {
    "shared-key" = {
      key_id = module.deploy_keys.deploy_key_ids["ci-read-only"]
      enable = ["my-group/project-b", "my-group/project-c"]
    }
  }
}
```

### From YAML file

```hcl
module "deploy_keys" {
  source = "../../modules/deploy-key"

  project          = "my-group/my-project"
  deploy_keys_file = "${path.module}/deploy_keys.yml"
}
```

```yaml
# deploy_keys.yml
ci-deploy:
  key: "ssh-ed25519 AAAAC3..."
  can_push: false
  expires_at: "2026-12-31T23:59:59Z"

shared-key:
  key: "ssh-ed25519 AAAAC3..."
  enable:
    - "my-group/project-b"
    - "my-group/project-c"
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `project` | The ID or path of the project to create deploy keys on | `string` | - | yes |
| `deploy_keys` | Deploy keys to create or enable (key is title) | `map(object)` | `{}` | no |
| `deploy_keys_file` | Path to YAML file with deploy keys | `string` | `null` | no |
| `create_only` | Ignore attribute changes after creation | `bool` | `false` | no |

### deploy_keys object

| Field | Description | Type | Required |
|-------|-------------|------|----------|
| `key` | Public SSH key body | `string` | yes (when creating) |
| `key_id` | Existing deploy key ID | `string` | yes (when enabling without creating) |
| `can_push` | Allow push access | `bool` | no |
| `expires_at` | Expiration date (RFC3339) | `string` | no |
| `enable` | List of project IDs to enable the key on | `list(string)` | no |

## Outputs

| Name | Description |
|------|-------------|
| `deploy_keys` | Map of created deploy keys with their attributes |
| `deploy_key_ids` | Map of deploy key titles to their deploy key IDs |
| `enabled_keys` | Map of enabled deploy keys (keyed by `name:project`) |
