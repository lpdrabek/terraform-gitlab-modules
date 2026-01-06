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
