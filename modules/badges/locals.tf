locals {
  yaml_content = try(yamldecode(file(var.badges_file)), {})

  badges_from_file = {
    for key, badge in local.yaml_content :
    key => {
      link_url  = try(badge.link_url, "")
      image_url = try(badge.image_url, "")
    }
  }

  all_badges = merge(local.badges_from_file, var.badges)
}
