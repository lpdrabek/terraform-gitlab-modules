module "project_membership_yaml" {
  source = "../../modules/membership"

  target = {
    type = "project"
    id   = data.gitlab_project.main_project.id
  }

  membership_file = "${path.module}/membership.yml"
}

module "project_membership_inline" {
  source = "../../modules/membership"

  target = {
    type = "project"
    id   = data.gitlab_project.main_project.id
  }

  membership = {
    developer = {
      users      = ["dev_user"]
      find_users = "username"
      expires_at = "2026-12-31"
    }
  }
}

module "group_membership" {
  source = "../../modules/membership"

  target = {
    type = "group"
    id   = data.gitlab_group.main_group.id
  }

  membership = {
    developer = {
      users      = ["dev_user"]
      find_users = "username"
    }
    maintainer = {
      users                         = ["admin@example.com"]
      find_users                    = "email"
      expires_at                    = "2027-12-31"
      skip_subresources_on_destroy  = true
      unassign_issuables_on_destroy = true
    }
  }
}



# output "project_membership_yaml" {
#   description = "Project memberships created from YAML"
#   value       = module.project_membership_yaml
# }

# output "project_membership_inline" {
#   description = "Project memberships created inline"
#   value       = module.project_membership_inline
# }

# output "group_membership" {
#   description = "Group memberships"
#   value       = module.group_membership
# }
