locals {
  all_milestone_maps = [
    for issue in local.all_issues :
    issue.milestone if issue.milestone != null
  ]

  all_milestones_flat = flatten([
    for milestone_map in local.all_milestone_maps : [
      for name, milestone in milestone_map : {
        name        = name
        description = try(milestone.description, null)
        state       = try(milestone.state, null)
        start_date  = try(milestone.start_date, null)
        due_date    = try(milestone.due_date, null)
      }
    ]
  ])

  distinct_milestones = {
    for name in distinct([for m in local.all_milestones_flat : m.name]) :
    name => {
      # Find first non-null attribute for this milestone name
      description = try(
        [for m in local.all_milestones_flat : m.description if m.name == name && m.description != null][0],
        null
      )
      state = try(
        [for m in local.all_milestones_flat : m.state if m.name == name && m.state != null][0],
        null
      )
      start_date = try(
        [for m in local.all_milestones_flat : m.start_date if m.name == name && m.start_date != null][0],
        null
      )
      due_date = try(
        [for m in local.all_milestones_flat : m.due_date if m.name == name && m.due_date != null][0],
        null
      )
    }
  }

  # Convert existing milestones list to map keyed by title
  existing_milestones_map = var.create_milestones ? {} : {
    for milestone in data.gitlab_project_milestones.all_milestones[0].milestones :
    milestone.title => {
      id           = milestone.milestone_id
      iid          = milestone.iid
      project_id   = milestone.project_id
      title        = milestone.title
      description  = milestone.description
      state        = milestone.state
      created_at   = milestone.created_at
      updated_at   = milestone.updated_at
      start_date   = milestone.start_date
      due_date     = milestone.due_date
      expired      = milestone.expired
      web_url      = milestone.web_url
      milestone_id = milestone.milestone_id
    }
  }

  # Unified milestone map - either from created milestones or existing ones
  all_milestones_map = var.create_milestones ? (
    length(module.project_milestones) > 0 ? module.project_milestones[0].milestones : {}
  ) : local.existing_milestones_map
}

module "project_milestones" {
  count  = var.create_milestones ? 1 : 0
  source = "../milestones"

  project_id = var.project_id
  milestones = local.distinct_milestones
}

data "gitlab_project_milestones" "all_milestones" {
  count   = var.create_milestones ? 0 : 1
  project = var.project_id
}
