locals {
  files_from_file = var.files_file != null ? {
    for key, f in yamldecode(file(var.files_file)) :
    key => {
      branch  = f.branch
      content = f.content

      encoding              = try(f.encoding, "text")
      author_email          = try(f.author_email, null)
      author_name           = try(f.author_name, null)
      commit_message        = try(f.commit_message, null)
      create_commit_message = try(f.create_commit_message, null)
      delete_commit_message = try(f.delete_commit_message, null)
      update_commit_message = try(f.update_commit_message, null)
      execute_filemode      = try(f.execute_filemode, null)
      overwrite_on_create   = try(f.overwrite_on_create, null)
      start_branch          = try(f.start_branch, null)
      timeouts              = try(f.timeouts, null)
    }
  } : {}

  all_files = merge(local.files_from_file, var.files)
}
