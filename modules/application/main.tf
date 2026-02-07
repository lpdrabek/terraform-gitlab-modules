resource "gitlab_application" "application" {
  for_each     = local.all_applications
  name         = each.key
  redirect_url = each.value.redirect_url
  scopes       = each.value.scopes
  confidential = each.value.confidential
}
