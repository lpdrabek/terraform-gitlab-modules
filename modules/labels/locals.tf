locals {
  labels_from_file = var.labels_file != null ? {
    for name, label in yamldecode(file(var.labels_file)) :
    name => {
      color       = try(label.color, null)
      description = try(label.description, null)
    }
  } : {}

  all_labels = merge(var.labels, local.labels_from_file)
}
