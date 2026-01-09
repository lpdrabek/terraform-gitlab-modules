module "project_badges" {
  source = "../../modules/badges"

  target = {
    type = "project"
    id   = data.gitlab_project.main_project.id
  }

  badges = {
    pipeline = {
      link_url  = "https://gitlab.com/%%{project_path}/-/pipelines"
      image_url = "https://gitlab.com/%%{project_path}/badges/%%{default_branch}/pipeline.svg"
    }
    coverage = {
      link_url  = "https://gitlab.com/%%{project_path}/-/jobs"
      image_url = "https://gitlab.com/%%{project_path}/badges/%%{default_branch}/coverage.svg"
    }
  }

  badges_file = "${path.module}/badges.yml"
}

module "group_badges" {
  source = "../../modules/badges"

  target = {
    type = "group"
    id   = data.gitlab_group.main_group.id
  }

  badges = {
    website = {
      link_url  = "https://example.com"
      image_url = "https://img.shields.io/badge/website-online-green.svg"
    }
  }
}

output "project_badges" {
  description = "Created project badges"
  value       = module.project_badges.badges
}

output "group_badges" {
  description = "Created group badges"
  value       = module.group_badges.badges
}
