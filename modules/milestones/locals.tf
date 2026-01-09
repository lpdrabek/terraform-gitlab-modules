locals {
  yaml_content = try(yamldecode(file(var.milestones_file)), {})

  milestones_from_file = {
    for name, milestone in local.yaml_content :
    name => {
      description = try(milestone.description, null)
      state       = try(milestone.state != "" ? milestone.state : null, null)
      start_date  = try(milestone.start_date != "" ? milestone.start_date : null, null)
      due_date    = try(milestone.due_date != "" ? milestone.due_date : null, null)
    }
  }

  all_milestones = merge(var.milestones, local.milestones_from_file)
}
