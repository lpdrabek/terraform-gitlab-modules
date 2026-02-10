# Example: YAML-based branch creation
module "branches_yaml" {
  source = "../../modules/branch"

  project       = data.gitlab_project.main_project.id
  branches_file = "${path.module}/branches.yml"

  # branches variable is required but can be empty when using YAML
  branches = {}
}

# Example: Inline branch creation
module "branches_inline" {
  source = "../../modules/branch"

  project = data.gitlab_project.main_project.id

  branches = {
    "develop2" = {
      create_from = "master"
    }
    "staging2" = {
      create_from = "master"
    }
    "feature/initial-setup2" = {
      create_from     = "develop"
      keep_on_destroy = true
    }
  }
}

# Example: Create branches from tags
# module "branches_from_tags" {
#   source = "../../modules/branch"
#
#   project = data.gitlab_project.main_project.id
#
#   branches = {
#     "hotfix/v1.0.1" = {
#       create_from = "v1.0.0"  # Create from a tag
#     }
#     "release/v1.1" = {
#       create_from = "main"
#     }
#   }
# }

# Example: Create branches from commits
# module "branches_from_commits" {
#   source = "../../modules/branch"
#
#   project = data.gitlab_project.main_project.id
#
#   branches = {
#     "bugfix/from-commit" = {
#       create_from = "abc123def456"  # Create from a specific commit SHA
#     }
#   }
# }

# Example: Keep branches on destroy (useful for long-lived branches)
# module "branches_keep" {
#   source = "../../modules/branch"
#
#   project = data.gitlab_project.main_project.id
#
#   branches = {
#     "production" = {
#       create_from     = "main"
#       keep_on_destroy = true  # Branch won't be deleted when resource is destroyed
#     }
#   }
# }


output "branches" {
  value = module.branches_yaml.branches
}
