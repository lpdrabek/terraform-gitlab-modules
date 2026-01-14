# Example: YAML-based tag protection (Free tier compatible)
module "tag_protection_yaml" {
  source = "../../modules/tag-protection"

  project   = data.gitlab_project.main_project.id
  tags_file = "${path.module}/tags.yml"
}

# Example: Inline tag protection (Free tier compatible)
# module "tag_protection_inline" {
#   source = "../../modules/tag-protection"
#
#   project = data.gitlab_project.main_project.id
#
#   tags = {
#     "v*" = {
#       create_access_level = "maintainer"
#     }
#     "release-*" = {
#       create_access_level = "maintainer"
#     }
#     "dev-*" = {
#       create_access_level = "developer"
#     }
#   }
# }

# Example: Create-only mode (ignores changes after initial creation)
# module "tag_protection_create_only" {
#   source = "../../modules/tag-protection"
#
#   project     = data.gitlab_project.main_project.id
#   create_only = true
#
#   tags = {
#     "legacy-*" = {
#       create_access_level = "maintainer"
#     }
#   }
# }

# =============================================================================
# Premium/Ultimate only examples
# =============================================================================
# The following features require GitLab Premium or Ultimate:
# - allowed_to_create (user-level)
# - groups_allowed_to_create (group-level)
#
# On Free tier, these will result in errors like:
# - "allowed_to_create is not allowed"

# Example: User-level permissions (requires GitLab Premium/Ultimate)
# module "tag_protection_with_users" {
#   source = "../../modules/tag-protection"
#
#   project = data.gitlab_project.main_project.id
#
#   tags = {
#     "v*" = {
#       search_by           = "username"
#       create_access_level = "no one"
#       allowed_to_create   = ["release_manager", "admin_user"]
#     }
#   }
# }

# Example: Group-level permissions (requires GitLab Premium/Ultimate)
# module "tag_protection_with_groups" {
#   source = "../../modules/tag-protection"
#
#   project = data.gitlab_project.main_project.id
#
#   tags = {
#     "release-*" = {
#       search_by                = "fullpath"
#       create_access_level      = "no one"
#       groups_allowed_to_create = ["my-group/release-managers"]
#     }
#   }
# }
