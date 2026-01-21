output "groups" {
  description = "Map of created groups"
  value       = merge(gitlab_group.groups, gitlab_group.create_only_groups)
  sensitive   = true
}

output "group_ids" {
  description = "Map of group names to IDs"
  value = {
    for name, group in merge(gitlab_group.groups, gitlab_group.create_only_groups) :
    name => group.id
  }
}

output "group_full_paths" {
  description = "Map of group names to full paths"
  value = {
    for name, group in merge(gitlab_group.groups, gitlab_group.create_only_groups) :
    name => group.full_path
  }
}

output "projects" {
  description = "Map of created projects (key format: group-name/project-name)"
  value = merge(flatten([
    for group_name, proj_module in module.projects : [
      for project_name, project in proj_module.projects :
      { "${group_name}/${project_name}" = project }
    ]
  ])...)
}

output "project_ids" {
  description = "Map of project paths to IDs"
  value = merge(flatten([
    for group_name, proj_module in module.projects : [
      for project_name, id in proj_module.project_ids :
      { "${group_name}/${project_name}" = id }
    ]
  ])...)
}
