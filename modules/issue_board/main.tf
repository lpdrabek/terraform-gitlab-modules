resource "gitlab_project_issue_board" "issue_board" {
  for_each = var.target.type == "project" ? local.all_boards : {}
  project  = var.target.id
  name     = each.key

  # No Gitlab EE license - no way to test this, sorry    
  labels       = each.value.labels
  assignee_id  = each.value.assignee_id
  milestone_id = each.value.milestone_id
  weight       = each.value.weight
  dynamic "lists" {
    for_each = each.value.lists != null ? each.value.lists : []
    content {
      assignee_id  = lists.value.assignee_id
      iteration_id = lists.value.iteration_id
      label_id     = lists.value.label_id
      milestone_id = lists.value.milestone_id
    }
  }
}

resource "gitlab_group_issue_board" "issue_board" {
  for_each = var.target.type == "group" ? local.all_boards : {}
  group    = var.target.id
  name     = each.key

  # No Gitlab EE license - no way to test this, sorry    
  labels       = each.value.labels
  milestone_id = each.value.milestone_id
  dynamic "lists" {
    for_each = each.value.lists != null ? each.value.lists : []
    content {
      label_id = lists.value.label_id
      position = lists.value.position
    }
  }
}
