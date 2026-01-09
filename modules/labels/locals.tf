locals {
  yaml_content = try(yamldecode(file(var.labels_file)), {})

  labels_from_file = {
    for name, label in local.yaml_content :
    name => {
      color       = try(label.color, null)
      description = try(label.description, null)
    }
  }

  all_labels = merge(var.labels, local.labels_from_file)
}
