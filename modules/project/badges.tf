module "badges" {
  source   = "gitlab.com/gitlab-utl/badges/gitlab"
  version  = ">= 1.0.0, < 2.0.0"
  for_each = local.all_projects

  target = {
    type = "project"
    id   = var.create_only ? gitlab_project.create_only_projects[each.key].id : gitlab_project.projects[each.key].id
  }

  badges      = each.value.badges
  badges_file = each.value.badges_file
  create_only = each.value.badges_create_only
}
