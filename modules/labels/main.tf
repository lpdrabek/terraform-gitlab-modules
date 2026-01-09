resource "random_id" "label_color" {
  for_each = {
    for name, label in local.all_labels :
    name => label
    if label.color == null
  }
  byte_length = 3
}

# Normal labels - fully managed
resource "gitlab_project_label" "project_labels" {
  for_each    = var.target.type == "project" && !var.create_only ? local.all_labels : {}
  project     = var.target.id
  name        = each.key
  description = each.value.description
  color       = each.value.color != null ? "${each.value.color}" : "#${random_id.label_color[each.key].hex}"
}

resource "gitlab_group_label" "group_labels" {
  for_each    = var.target.type == "group" && !var.create_only ? local.all_labels : {}
  group       = var.target.id
  name        = each.key
  description = each.value.description
  color       = each.value.color != null ? "${each.value.color}" : "#${random_id.label_color[each.key].hex}"
}

# Create-only labels - ignore changes after creation
resource "gitlab_project_label" "create_only_project_labels" {
  for_each    = var.target.type == "project" && var.create_only ? local.all_labels : {}
  project     = var.target.id
  name        = each.key
  description = each.value.description
  color       = each.value.color != null ? "${each.value.color}" : "#${random_id.label_color[each.key].hex}"

  lifecycle {
    ignore_changes = [name, description, color]
  }
}

resource "gitlab_group_label" "create_only_group_labels" {
  for_each    = var.target.type == "group" && var.create_only ? local.all_labels : {}
  group       = var.target.id
  name        = each.key
  description = each.value.description
  color       = each.value.color != null ? "${each.value.color}" : "#${random_id.label_color[each.key].hex}"

  lifecycle {
    ignore_changes = [name, description, color]
  }
}
