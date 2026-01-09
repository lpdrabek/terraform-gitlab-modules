output "labels" {
  description = "Map of created labels with their attributes"
  value = var.target.type == "project" ? (
    var.create_only ? gitlab_project_label.create_only_project_labels : gitlab_project_label.project_labels
    ) : (
    var.create_only ? gitlab_group_label.create_only_group_labels : gitlab_group_label.group_labels
  )
}
