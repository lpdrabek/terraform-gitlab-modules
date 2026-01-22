locals {
  yaml_content = try(yamldecode(file(var.schedules_file)), {})

  schedules_from_file = {
    for key, schedule in local.yaml_content :
    key => {
      cron           = schedule.cron
      description    = schedule.description
      ref            = schedule.ref
      active         = try(schedule.active, null)
      cron_timezone  = try(schedule.cron_timezone, null)
      take_ownership = try(schedule.take_ownership, null)
      variables = {
        for var_key, var_data in try(schedule.variables, {}) :
        var_key => {
          value         = var_data.value
          variable_type = try(var_data.variable_type, "env_var")
        }
      }
    }
  }

  all_schedules = merge(local.schedules_from_file, var.schedules)
}
