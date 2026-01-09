resource "gitlab_project_issue" "issues" {
  for_each              = { for k, v in local.all_issues : k => v if !var.create_only }
  project               = var.project_id
  title                 = each.value.title
  description           = each.value.description
  assignee_ids          = each.value.assignee_ids
  confidential          = each.value.confidential
  created_at            = each.value.created_at
  delete_on_destroy     = each.value.delete_on_destroy
  discussion_locked     = each.value.discussion_locked
  discussion_to_resolve = each.value.discussion_to_resolve
  due_date              = each.value.due_date
  epic_issue_id         = each.value.epic_issue_id
  issue_type            = each.value.issue_type
  state                 = each.value.state
  updated_at            = each.value.updated_at
  weight                = each.value.weight

  merge_request_to_resolve_discussions_of = each.value.merge_request_to_resolve_discussions_of
  labels                                  = each.value.labels != null ? keys(each.value.labels) : null

  milestone_id = each.value.milestone != null ? local.all_milestones_map[keys(each.value.milestone)[0]].milestone_id : null

  depends_on = [module.project_labels, module.project_milestones]
}

resource "gitlab_project_issue" "create_only_issues" {
  for_each              = { for k, v in local.all_issues : k => v if var.create_only }
  project               = var.project_id
  title                 = each.value.title
  description           = each.value.description
  assignee_ids          = each.value.assignee_ids
  confidential          = each.value.confidential
  created_at            = each.value.created_at
  delete_on_destroy     = each.value.delete_on_destroy
  discussion_locked     = each.value.discussion_locked
  discussion_to_resolve = each.value.discussion_to_resolve
  due_date              = each.value.due_date
  epic_issue_id         = each.value.epic_issue_id
  issue_type            = each.value.issue_type
  state                 = each.value.state
  updated_at            = each.value.updated_at
  weight                = each.value.weight

  merge_request_to_resolve_discussions_of = each.value.merge_request_to_resolve_discussions_of
  labels                                  = each.value.labels != null ? keys(each.value.labels) : null

  milestone_id = each.value.milestone != null ? local.all_milestones_map[keys(each.value.milestone)[0]].milestone_id : null

  depends_on = [module.project_labels, module.project_milestones]

  lifecycle {
    ignore_changes = [title, description, assignee_ids, confidential, discussion_locked,
    discussion_to_resolve, due_date, epic_issue_id, issue_type, labels, milestone_id, state, updated_at, weight]
  }
}
