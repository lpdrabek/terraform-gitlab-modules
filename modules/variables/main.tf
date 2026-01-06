resource "gitlab_project_variable" "project_variables" {
  for_each          = var.target.type == "project" ? local.all_variables : {}
  project           = var.target.id
  key               = each.key
  value             = each.value.value
  description       = each.value.description
  environment_scope = each.value.environment_scope
  hidden            = each.value.hidden
  masked            = each.value.masked
  protected         = each.value.protected
  raw               = each.value.raw
  variable_type     = each.value.variable_type
}

resource "gitlab_group_variable" "group_variables" {
  for_each          = var.target.type == "group" ? local.all_variables : {}
  group             = var.target.id
  key               = each.key
  value             = each.value.value
  description       = each.value.description
  environment_scope = each.value.environment_scope
  hidden            = each.value.hidden
  masked            = each.value.masked
  protected         = each.value.protected
  raw               = each.value.raw
  variable_type     = each.value.variable_type
}
