module "issues" {
  source   = "gitlab.com/gitlab-utl/issues/gitlab"
  version  = ">= 1.0.0, < 2.0.0"
  for_each = local.all_projects

  project_id  = var.create_only ? gitlab_project.create_only_projects[each.key].id : gitlab_project.projects[each.key].id
  issues      = each.value.issues
  issues_file = each.value.issues_file
  create_only = each.value.issues_create_only

  # Don't create labels/milestones in issues module - they're created by the project's own modules
  create_labels     = false
  create_milestones = false

  depends_on = [module.labels, module.milestones]
}
