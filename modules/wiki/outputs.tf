output "pages" {
  description = "Map of created wiki pages with their attributes"
  value       = var.create_only ? gitlab_project_wiki_page.create_only_pages : gitlab_project_wiki_page.pages
}

output "slugs" {
  description = "Map of wiki page keys to their slugs"
  value = var.create_only ? {
    for key, page in gitlab_project_wiki_page.create_only_pages :
    key => page.slug
    } : {
    for key, page in gitlab_project_wiki_page.pages :
    key => page.slug
  }
}
