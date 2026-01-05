output "labels" {
  value = var.target.type == "project" ? (
    gitlab_project_label.project_labels
    ) : (
  gitlab_group_label.group_labels)
}
