output "milestones" {
  description = "Map of created milestones with their attributes"
  value = var.create_only ? {
    for key, milestone in gitlab_project_milestone.create_only_milestones :
    key => milestone
    } : {
    for key, milestone in gitlab_project_milestone.milestones :
    key => milestone
  }
}

output "milestone_ids" {
  description = "Map of milestone titles to their IDs"
  value = var.create_only ? {
    for key, milestone in gitlab_project_milestone.create_only_milestones :
    key => milestone.milestone_id
    } : {
    for key, milestone in gitlab_project_milestone.milestones :
    key => milestone.milestone_id
  }
}

output "milestone_iids" {
  description = "Map of milestone titles to their project-specific IIDs"
  value = var.create_only ? {
    for key, milestone in gitlab_project_milestone.create_only_milestones :
    key => milestone.iid
    } : {
    for key, milestone in gitlab_project_milestone.milestones :
    key => milestone.iid
  }
}
