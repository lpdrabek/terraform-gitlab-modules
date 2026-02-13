resource "gitlab_repository_file" "file" {
  for_each = local.all_files

  project   = var.project
  file_path = each.key
  branch    = each.value.branch
  content   = each.value.content
  encoding  = each.value.encoding

  author_email = each.value.author_email
  author_name  = each.value.author_name

  commit_message        = each.value.create_commit_message == null ? coalesce(each.value.commit_message, "Update ${each.key}") : null
  create_commit_message = each.value.create_commit_message
  update_commit_message = each.value.update_commit_message
  delete_commit_message = each.value.delete_commit_message
  execute_filemode      = each.value.execute_filemode
  overwrite_on_create   = each.value.overwrite_on_create
  start_branch          = each.value.start_branch

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}
