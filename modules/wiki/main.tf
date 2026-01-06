
resource "gitlab_project_wiki_page" "pages" {
  for_each = var.create_only ? {} : local.all_pages
  project  = var.project_id
  title    = each.value.title != null ? each.value.title : replace(each.key, "/[-–—_|•]+/", " ")
  content  = each.value.content
  format   = each.value.format
}

resource "gitlab_project_wiki_page" "create_only_pages" {
  for_each = var.create_only ? local.all_pages : {}
  project  = var.project_id
  title    = each.value.title != null ? each.value.title : replace(each.key, "/[-–—_|•]+/", " ")
  content  = each.value.content
  format   = each.value.format

  lifecycle {
    ignore_changes = [title, content, format]
  }
}
