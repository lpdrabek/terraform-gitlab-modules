locals {
  milestones_from_file = var.milestones_file != null ? {
    for name, milestone in yamldecode(file(var.milestones_file)) :
    name => {
      description = try(milestone.description, null)
      state       = try(milestone.state != "" ? milestone.state : null, null)
      start_date  = try(milestone.start_date != "" ? milestone.start_date : null, null)
      due_date    = try(milestone.due_date != "" ? milestone.due_date : null, null)
    }
  } : {}

  all_milestones = merge(var.milestones, local.milestones_from_file)
}
