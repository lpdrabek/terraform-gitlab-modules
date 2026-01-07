locals {
  badges_from_file = var.badges_file != null ? {
    for key, badge in yamldecode(file(var.badges_file)) :
    key => {
      link_url  = try(badge.link_url, "")
      image_url = try(badge.image_url, "")
    }
  } : {}

  all_badges = merge(local.badges_from_file, var.badges)
}
