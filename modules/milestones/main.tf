resource "gitlab_project_milestone" "milestones" {
  for_each    = var.create_only ? {} : local.all_milestones
  project     = var.project_id
  title       = each.key
  description = each.value.description
  due_date    = each.value.due_date
  start_date  = each.value.start_date
  state       = each.value.state
}

resource "gitlab_project_milestone" "create_only_milestones" {
  for_each    = var.create_only ? local.all_milestones : {}
  project     = var.project_id
  title       = each.key
  description = each.value.description
  due_date    = each.value.due_date
  start_date  = each.value.start_date
  state       = each.value.state

  lifecycle {
    ignore_changes = [
      title, description, due_date, start_date, state
    ]
  }
}
