# Normal badges - fully managed
resource "gitlab_project_badge" "badges" {
  for_each  = var.target.type == "project" && !var.create_only ? local.all_badges : {}
  project   = var.target.id
  name      = each.key
  link_url  = each.value.link_url
  image_url = each.value.image_url
}

resource "gitlab_group_badge" "badges" {
  for_each  = var.target.type == "group" && !var.create_only ? local.all_badges : {}
  group     = var.target.id
  name      = each.key
  link_url  = each.value.link_url
  image_url = each.value.image_url
}

# Create-only badges - ignore changes after creation
resource "gitlab_project_badge" "create_only_badges" {
  for_each  = var.target.type == "project" && var.create_only ? local.all_badges : {}
  project   = var.target.id
  name      = each.key
  link_url  = each.value.link_url
  image_url = each.value.image_url

  lifecycle {
    ignore_changes = [name, link_url, image_url]
  }
}

resource "gitlab_group_badge" "create_only_badges" {
  for_each  = var.target.type == "group" && var.create_only ? local.all_badges : {}
  group     = var.target.id
  name      = each.key
  link_url  = each.value.link_url
  image_url = each.value.image_url

  lifecycle {
    ignore_changes = [name, link_url, image_url]
  }
}
