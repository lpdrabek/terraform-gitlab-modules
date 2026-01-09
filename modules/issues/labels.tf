locals {
  all_label_maps = [
    for issue in local.all_issues :
    issue.labels if issue.labels != null
  ]

  all_labels_flat = flatten([
    for label_map in local.all_label_maps : [
      for name, label in label_map : {
        name        = name
        color       = try(label.color, null)
        description = try(label.description, null)
      }
    ]
  ])

  distinct_labels = {
    for name in distinct([for l in local.all_labels_flat : l.name]) :
    name => {
      # Find first non-null attribute for this label name
      color = try(
        [for l in local.all_labels_flat : l.color if l.name == name && l.color != null][0],
        null
      )
      description = try(
        [for l in local.all_labels_flat : l.description if l.name == name && l.description != null][0],
        null
      )
    }
  }
}

module "project_labels" {
  source = "../labels"
  count  = var.create_labels ? 1 : 0

  labels = local.distinct_labels
  target = {
    type = "project"
    id   = var.project_id
  }
}
