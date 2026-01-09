module "labels" {
  source   = "../labels"
  for_each = local.all_projects

  target = {
    type = "project"
    id   = var.create_only ? gitlab_project.create_only_projects[each.key].id : gitlab_project.projects[each.key].id
  }

  labels      = each.value.labels
  labels_file = each.value.labels_file
  create_only = each.value.labels_create_only
}
