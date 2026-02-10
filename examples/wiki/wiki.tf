module "wiki_pages" {
  source = "../../modules/wiki"

  project_id = data.gitlab_project.main_project.id

  pages = {
    home = {
      title   = "Home"
      content = "Welcome to the project wiki."
    }
    "getting-started" = {
      title   = "Getting Started"
      content = "## Prerequisites\n\nYou will need:\n- Terraform >= 1.6.0\n- GitLab API token"
    }
    "architecture" = {
      content = "Overview of the system architecture."
    }
  }

  pages_file = "${path.module}/wiki.yml"
}

module "wiki_create_only" {
  source = "../../modules/wiki"

  project_id  = data.gitlab_project.main_project.id
  create_only = true

  pages = {
    "runbook" = {
      title   = "Runbook"
      content = "Operational runbook - edit freely in GitLab UI after creation."
    }
  }
}

output "wiki_pages" {
  description = "Created wiki pages"
  value       = module.wiki_pages.pages
}

output "wiki_slugs" {
  description = "Wiki page slugs"
  value       = module.wiki_pages.slugs
}
