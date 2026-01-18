# Example: YAML-based push mirror configuration
# module "push_mirrors_yaml" {
#   source = "../../modules/project-mirror"
#
#   type        = "push"
#   target_file = "${path.module}/mirrors.yml"
# }

# Example: Push mirror with password authentication (inline)
module "push_mirror" {
  source = "../../modules/project-mirror"

  type = "push"

  target = {
    (data.gitlab_project.main_project.id) = {
      url                     = "https://github.com/example/mirror-repo.git"
      auth_method             = "password"
      enabled                 = true
      only_protected_branches = true
    }
  }
}

# Example: Push mirror with SSH authentication
module "push_mirror_ssh" {
  source = "../../modules/project-mirror"

  type = "push"

  target = {
    (data.gitlab_project.main_project.id) = {
      url                 = "ssh://git@github.com/example/mirror-repo.git"
      auth_method         = "ssh_public_key"
      enabled             = true
      keep_divergent_refs = true
    }
  }
}

output "test" {
  value = module.push_mirror_ssh.mirror_keys
}

# Example: Push mirror with branch regex (Premium/Ultimate only)
# module "push_mirror_branch_filter" {
#   source = "../../modules/project-mirror"
#
#   type = "push"
#
#   target = {
#     (data.gitlab_project.main_project.id) = {
#       url                 = "https://github.com/example/mirror-repo.git"
#       auth_method         = "password"
#       mirror_branch_regex = "^(main|release-.*)$"
#     }
#   }
# }

# Example: Pull mirror with authentication
# module "pull_mirror" {
#   source = "../../modules/project-mirror"
#
#   type = "pull"
#
#   target = {
#     (data.gitlab_project.main_project.id) = {
#       url                                 = "https://github.com/example/source-repo.git"
#       auth_user                           = "oauth2"
#       auth_password                       = var.github_token
#       enabled                             = true
#       mirror_overwrites_diverged_branches = true
#       mirror_trigger_builds               = true
#     }
#   }
# }

# Example: Pull mirror - protected branches only
# module "pull_mirror_protected" {
#   source = "../../modules/project-mirror"
#
#   type = "pull"
#
#   target = {
#     (data.gitlab_project.main_project.id) = {
#       url                            = "https://github.com/example/source-repo.git"
#       auth_user                      = "oauth2"
#       auth_password                  = var.github_token
#       only_mirror_protected_branches = true
#     }
#   }
# }

# Example: Multiple push mirrors
# module "multiple_push_mirrors" {
#   source = "../../modules/project-mirror"
#
#   type = "push"
#
#   target = {
#     "group/project-1" = {
#       url         = "https://github.com/example/project-1-mirror.git"
#       auth_method = "password"
#     }
#     "group/project-2" = {
#       url         = "https://github.com/example/project-2-mirror.git"
#       auth_method = "password"
#     }
#   }
# }
