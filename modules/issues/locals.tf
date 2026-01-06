locals {
  issues_from_file = var.issues_file != null ? {
    for name, issue in yamldecode(file(var.issues_file)) :
    name => {
      title                                   = issue.title
      description                             = try(issue.description, null)
      assignee_ids                            = try(issue.assignee_ids, null)
      confidential                            = try(issue.confidential, null)
      created_at                              = try(issue.created_at, null)
      delete_on_destroy                       = try(issue.delete_on_destroy, null)
      discussion_locked                       = try(issue.discussion_locked, null)
      discussion_to_resolve                   = try(issue.discussion_to_resolve, null)
      due_date                                = try(issue.due_date, null)
      epic_issue_id                           = try(issue.epic_issue_id, null)
      iid                                     = try(issue.iid, null)
      issue_type                              = try(issue.issue_type, null)
      labels                                  = try(issue.labels, null)
      merge_request_to_resolve_discussions_of = try(issue.merge_request_to_resolve_discussions_of, null)
      milestone                               = try(issue.milestone, null)
      state                                   = try(issue.state, null)
      updated_at                              = try(issue.updated_at, null)
      weight                                  = try(issue.weight, null)
    }
  } : {}

  all_issues = merge(var.issues, local.issues_from_file)
}
