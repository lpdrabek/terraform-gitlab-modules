output "labels" {
  description = "Map of created labels with their attributes"
  value = var.target.type == "project" ? (
    var.create_only ? gitlab_project_label.create_only_project_labels : gitlab_project_label.project_labels
    ) : (
    var.create_only ? gitlab_group_label.create_only_group_labels : gitlab_group_label.group_labels
  )
}

output "label_ids" {
  description = "Map of label names to their IDs"
  value = var.target.type == "project" ? (
    var.create_only ? {
      for name, label in gitlab_project_label.create_only_project_labels :
      name => label.label_id
      } : {
      for name, label in gitlab_project_label.project_labels :
      name => label.label_id
    }
    ) : (
    var.create_only ? {
      for name, label in gitlab_group_label.create_only_group_labels :
      name => label.label_id
      } : {
      for name, label in gitlab_group_label.group_labels :
      name => label.label_id
    }
  )
}
