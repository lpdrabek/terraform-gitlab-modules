# Example: YAML-based branch protection (Free tier compatible)
module "branch_protection_yaml" {
  source = "../../modules/branch-protection"

  project       = data.gitlab_project.main_project.id
  branches_file = "${path.module}/branches.yml"
}

# Example: Inline branch protection (Free tier compatible)
# module "branch_protection_inline" {
#   source = "../../modules/branch-protection"
#
#   project = data.gitlab_project.main_project.id
#
#   branches = {
#     "main" = {
#       push_access_level      = "maintainer"
#       merge_access_level     = "developer"
#       unprotect_access_level = "maintainer"
#       allow_force_push       = false
#     }
#     "develop" = {
#       push_access_level  = "developer"
#       merge_access_level = "developer"
#       allow_force_push   = false
#     }
#   }
# }

# Example: Create-only mode (ignores changes after initial creation)
# module "branch_protection_create_only" {
#   source = "../../modules/branch-protection"
#
#   project     = data.gitlab_project.main_project.id
#   create_only = true
#
#   branches = {
#     "feature/*" = {
#       push_access_level  = "developer"
#       merge_access_level = "developer"
#       allow_force_push   = true
#     }
#   }
# }

# =============================================================================
# Premium/Ultimate only examples
# =============================================================================
# The following features require GitLab Premium or Ultimate:
# - allowed_to_push, allowed_to_merge, allowed_to_unprotect (user-level)
# - groups_allowed_to_push, groups_allowed_to_merge, groups_allowed_to_unprotect
# - code_owner_approval_required
#
# On Free tier, these will result in errors like:
# - "Push access levels user must be blank"
# - "Merge access levels group must be blank"

# Example: User-level permissions (requires GitLab Premium/Ultimate)
# module "branch_protection_with_users" {
#   source = "../../modules/branch-protection"
#
#   project = data.gitlab_project.main_project.id
#
#   branches = {
#     "main" = {
#       search_by                    = "username"
#       push_access_level            = "maintainer"
#       merge_access_level           = "developer"
#       code_owner_approval_required = true
#       allowed_to_push              = ["admin_user"]
#       allowed_to_merge             = ["dev_user", "admin_user"]
#     }
#   }
# }

# Example: Group-level permissions (requires GitLab Premium/Ultimate)
# module "branch_protection_with_groups" {
#   source = "../../modules/branch-protection"
#
#   project = data.gitlab_project.main_project.id
#
#   branches = {
#     "release/*" = {
#       search_by               = "fullpath"
#       push_access_level       = "no one"
#       merge_access_level      = "maintainer"
#       unprotect_access_level  = "maintainer"
#       groups_allowed_to_push  = ["my-group/release-managers"]
#       groups_allowed_to_merge = ["my-group/release-managers"]
#     }
#   }
# }
