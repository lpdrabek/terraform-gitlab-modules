# Wiki Module Example

This example demonstrates all features of the `wiki` module.

## What it shows

- **HCL-defined pages** - Wiki pages defined directly in Terraform
- **YAML file loading** - Additional pages loaded from `wiki.yml`
- **Title from key** - Automatic title derivation when title is omitted
- **Create-only mode** - Pages that won't be overwritten after initial creation

## Usage

```bash
export GITLAB_TOKEN="your-token"
tofu init
tofu plan
tofu apply
```

## Prerequisites

- Edit `main.tf` with your project path
