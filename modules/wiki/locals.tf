locals {
  pages_from_file = var.pages_file != null ? {
    for key, page in yamldecode(file(var.pages_file)) :
    key => {
      title   = try(page.title, null)
      content = try(page.content, null)
      format  = try(page.format, "markdown")
    }
  } : {}

  all_pages = merge(local.pages_from_file, var.pages)
}
