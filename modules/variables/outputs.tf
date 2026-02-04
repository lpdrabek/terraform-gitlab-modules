output "project_variables" {
  description = "Map of created project variables"
  value       = gitlab_project_variable.project_variables
  sensitive   = true
}

output "group_variables" {
  description = "Map of created group variables"
  value       = gitlab_group_variable.group_variables
  sensitive   = true
}

output "variables" {
  description = "Map of all created variables (project or group depending on target)"
  value       = var.target.type == "project" ? gitlab_project_variable.project_variables : gitlab_group_variable.group_variables
  sensitive   = true
}

output "variable_keys" {
  description = "List of created variable keys (names)"
  value       = keys(var.target.type == "project" ? gitlab_project_variable.project_variables : gitlab_group_variable.group_variables)
}

output "variable_metadata" {
  description = "Map of variable keys to their non-sensitive metadata"
  value = var.target.type == "project" ? {
    for key, v in gitlab_project_variable.project_variables :
    key => {
      environment_scope = v.environment_scope
      variable_type     = v.variable_type
      protected         = v.protected
      masked            = v.masked
      hidden            = v.hidden
      raw               = v.raw
    }
    } : {
    for key, v in gitlab_group_variable.group_variables :
    key => {
      environment_scope = v.environment_scope
      variable_type     = v.variable_type
      protected         = v.protected
      masked            = v.masked
      hidden            = v.hidden
      raw               = v.raw
    }
  }
}
