# Repository File Module

Manages files in a GitLab project repository.

## Usage

### Using HCL variables

```hcl
module "files" {
  source = "../../modules/repository-file"

  project = "123"

  files = {
    "README.md" = {
      branch  = "main"
      content = "# My Project\n\nProject description."
    }
    ".gitignore" = {
      branch         = "main"
      content        = "*.log\nnode_modules/"
      commit_message = "Add gitignore"
    }
  }
}
```

### Using YAML file

```hcl
module "files" {
  source = "../../modules/repository-file"

  project    = "123"
  files_file = "${path.module}/files.yml"
}
```

### With specific commit messages

```hcl
module "files" {
  source = "../../modules/repository-file"

  project = "123"

  files = {
    "config.json" = {
      branch                = "main"
      content               = jsonencode({ version = "1.0.0" })
      create_commit_message = "feat: add config"
      update_commit_message = "chore: update config"
      delete_commit_message = "chore: remove config"
    }
  }
}
```

### With author information

```hcl
module "files" {
  source = "../../modules/repository-file"

  project = "123"

  files = {
    "docs/guide.md" = {
      branch       = "main"
      content      = "# Guide"
      author_name  = "Terraform"
      author_email = "terraform@example.com"
    }
  }
}
```

### Binary files with base64 encoding

```hcl
module "files" {
  source = "../../modules/repository-file"

  project = "123"

  files = {
    "images/logo.png" = {
      branch   = "main"
      content  = filebase64("${path.module}/logo.png")
      encoding = "base64"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `project` | The name or ID of the project | `string` | - | yes |
| `files` | Map of repository files to create (key is file_path) | `map(object)` | `{}` | no |
| `files_file` | Path to YAML file containing files configuration | `string` | `null` | no |

### Files object

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `branch` | Branch to commit to | `string` | - |
| `content` | File content | `string` | - |
| `encoding` | Content encoding (`text` or `base64`) | `string` | `"text"` |
| `commit_message` | Commit message | `string` | `"Update {file_path}"` |
| `create_commit_message` | Commit message for create (requires all three) | `string` | `null` |
| `update_commit_message` | Commit message for update (requires all three) | `string` | `null` |
| `delete_commit_message` | Commit message for delete (requires all three) | `string` | `null` |
| `author_name` | Commit author name (requires author_email) | `string` | `null` |
| `author_email` | Commit author email (requires author_name) | `string` | `null` |
| `execute_filemode` | Enable execute flag on the file | `bool` | `null` |
| `overwrite_on_create` | Overwrite existing files on create | `bool` | `null` |
| `start_branch` | Branch to start new commit from | `string` | `null` |
| `timeouts` | Timeout configuration | `object` | `null` |

## Outputs

| Name | Description |
|------|-------------|
| `files` | Map of created repository files with their attributes |

## Validations

- `file_path` (map key) cannot start with `/` or `./`
- `encoding` must be `text` or `base64`
- `create_commit_message`, `update_commit_message`, `delete_commit_message` must all be specified together or none
- `author_name` and `author_email` must both be specified together or none
- `author_email` must be a valid email address
