resource "random_id" "label_color" {
  for_each = {
    for name, label in local.all_labels :
    name => label
    if label.color == null
  }
  byte_length = 3
}

resource "gitlab_project_label" "project_labels" {
  for_each    = var.target.type == "project" ? local.all_labels : {}
  project     = var.target.id
  name        = each.key
  description = each.value.description
  color       = each.value.color != null ? "${each.value.color}" : "#${random_id.label_color[each.key].hex}"
}

resource "gitlab_group_label" "group_labels" {
  for_each    = var.target.type == "group" ? local.all_labels : {}
  group       = var.target.id
  name        = each.key
  description = each.value.description
  color       = each.value.color != null ? "${each.value.color}" : "#${random_id.label_color[each.key].hex}"
}
