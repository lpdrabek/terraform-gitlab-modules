locals {
  yaml_content = try(yamldecode(file(var.variables_file)), {})

  variables_from_file = {
    for key, variable in local.yaml_content :
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
  }

  all_variables = merge(local.variables_from_file, var.variables)
}
