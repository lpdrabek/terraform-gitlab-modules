resource "gitlab_pipeline_trigger" "pipeline_trigger" {
  for_each    = { for k, v in local.all_projects : k => v if v.pipeline_trigger != null }
  project     = var.create_only ? gitlab_project.create_only_projects[each.key].id : gitlab_project.projects[each.key].id
  description = each.value.pipeline_trigger
}
