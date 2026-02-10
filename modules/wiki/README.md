# Wiki Module

Manages wiki pages for a GitLab project.

> **Warning:** The GitLab wiki API creates and destroys pages one at a time.
> When managing multiple pages, you may need to run `apply` multiple times.
> Or use apply -parallelism=1

## Usage

### Using HCL variables

```hcl
module "wiki" {
  source = "../../modules/wiki"

  project_id = "123"

  pages = {
    home = {
      title   = "Home"
      content = "Welcome to the project wiki."
    }
    "getting-started" = {
      content = "How to get started with the project."
    }
  }
}
```

### Using YAML file

```hcl
module "wiki" {
  source = "../../modules/wiki"

  project_id = "123"
  pages_file = "${path.module}/wiki.yml"
}
```

### Create-only mode

```hcl
module "wiki" {
  source = "../../modules/wiki"

  project_id  = "123"
  create_only = true

  pages = {
    home = {
      title   = "Home"
      content = "Initial content - edits in GitLab UI will be preserved."
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `project_id` | ID of the project for the wiki pages | `string` | - | yes |
| `pages` | Map of pages to create in the project | `map(object)` | `{}` | no |
| `pages_file` | Path to YAML file containing wiki pages | `string` | `null` | no |
| `create_only` | If true, ignore attribute changes after creation | `bool` | `false` | no |

### Pages object

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `title` | Page title (derived from map key if omitted) | `string` | `null` |
| `content` | Page content | `string` | `null` |
| `format` | Content format (`markdown`, `rdoc`, `asciidoc`) | `string` | `"markdown"` |

## Outputs

| Name | Description |
|------|-------------|
| `pages` | Map of created wiki pages with their attributes |
| `slugs` | Map of wiki page keys to their slugs |
