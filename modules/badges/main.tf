resource "gitlab_project_badge" "badges" {
  for_each  = var.target.type == "project" ? local.all_badges : {}
  project   = var.target.id
  name      = each.key
  link_url  = each.value.link_url
  image_url = each.value.image_url
}

resource "gitlab_group_badge" "badges" {
  for_each  = var.target.type == "group" ? local.all_badges : {}
  group     = var.target.id
  name      = each.key
  link_url  = each.value.link_url
  image_url = each.value.image_url
}
