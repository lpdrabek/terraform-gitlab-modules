module "milestones" {
  source   = "../milestones"
  for_each = local.all_projects

  project_id      = var.create_only ? gitlab_project.create_only_projects[each.key].id : gitlab_project.projects[each.key].id
  milestones      = each.value.milestones
  milestones_file = each.value.milestones_file
  create_only     = each.value.milestones_create_only
}
