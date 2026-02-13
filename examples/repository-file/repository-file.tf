# Example: YAML-based repository file creation
module "files_yaml" {
  source = "../../modules/repository-file"

  project    = data.gitlab_project.main_project.id
  files_file = "${path.module}/files.yml"

  files = {}
}

# Example: Inline repository file creation
module "files_inline" {
  source = "../../modules/repository-file"

  project = data.gitlab_project.main_project.id

  files = {
    "README.md" = {
      branch  = "master"
      content = "# My Project\n\nThis is a sample project."
    }
    ".gitignore" = {
      branch         = "master"
      content        = "*.log\n*.tmp\nnode_modules/\n.env"
      commit_message = "Add gitignore file"
    }
    "docs/getting-started.md" = {
      branch                = "master"
      content               = "# Getting Started\n\nFollow these steps to get started."
      author_name           = "Terraform"
      author_email          = "terraform@example.com"
      create_commit_message = "Add getting started guide"
      update_commit_message = "Update getting started guide"
      delete_commit_message = "Remove getting started guide"
    }
  }
}

# Example: Create files with base64 encoding (for binary files)
module "files_binary" {
  source = "../../modules/repository-file"

  project = data.gitlab_project.main_project.id

  files = {
    "images/logo.png" = {
      branch   = "master"
      content  = filebase64("${path.module}/logo.png")
      encoding = "base64"
    }
  }
}

# Example: Create files on a feature branch
module "files_feature_branch" {
  source = "../../modules/repository-file"

  project = data.gitlab_project.main_project.id

  files = {
    "config/settings.json" = {
      branch       = "feature/new-config"
      start_branch = "master"
      content = jsonencode({
        debug   = true
        version = "1.0.0"
      })
      commit_message = "Add new configuration file"
    }
  }
}

# Example: Create executable scripts
module "files_executable" {
  source = "../../modules/repository-file"

  project = data.gitlab_project.main_project.id

  files = {
    "scripts/deploy.sh" = {
      branch           = "master"
      content          = "#!/bin/bash\necho 'Deploying...'"
      execute_filemode = true
      commit_message   = "Add deployment script"
    }
  }
}

# Example: Overwrite existing files on create
module "files_overwrite" {
  source = "../../modules/repository-file"

  project = data.gitlab_project.main_project.id

  files = {
    "CHANGELOG.md" = {
      branch              = "master"
      content             = "# Changelog\n\n## v1.0.0\n- Initial release"
      overwrite_on_create = true
    }
  }
}

output "files" {
  description = "Created repository files"
  value       = module.files_inline.files
}
