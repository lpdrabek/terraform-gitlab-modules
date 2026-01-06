locals {
  variables_from_file = var.variables_file != null ? {
    for key, variable in yamldecode(file(var.variables_file)) :
    key => {
      value             = try(variable.value, "")
      description       = try(variable.description, null)
      environment_scope = try(variable.environment_scope, null)
      hidden            = try(variable.hidden, false)
      masked            = try(variable.masked, false)
      protected         = try(variable.protected, false)
      raw               = try(variable.raw, false)
      variable_type     = try(variable.variable_type, "env_var")
    }
  } : {}

  all_variables = merge(local.variables_from_file, var.variables)
}
