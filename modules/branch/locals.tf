locals {
  branches_from_file = {
    for branch_name, config in try(yamldecode(file(var.branches_file)), {}) :
    branch_name => {
      create_from     = config.create_from
      keep_on_destroy = try(config.keep_on_destroy, null)
    }
  }
  all_branches = merge(local.branches_from_file, var.branches)
}
