# Repository File Module Example

This example demonstrates all features of the `repository-file` module.

## What it shows

- **HCL-defined files** - Repository files defined directly in Terraform
- **YAML file loading** - Additional files loaded from `files.yml`
- **Custom commit messages** - Both general and specific (create/update/delete)
- **Author information** - Custom author name and email for commits
- **Binary files** - Base64 encoding for non-text files (commented example)
- **Feature branches** - Creating files on new branches from a start branch
- **Executable scripts** - Setting execute filemode on shell scripts
- **Overwrite on create** - Replacing existing files during initial creation

## Usage

```bash
export GITLAB_TOKEN="your-token"
tofu init
tofu plan
tofu apply
```

## Prerequisites

- Edit `main.tf` with your project path
- Ensure the target branch exists in your project
