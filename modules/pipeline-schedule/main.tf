resource "gitlab_pipeline_schedule" "pipeline_schedule" {
  for_each       = local.all_schedules
  project        = var.project_id
  cron           = each.value.cron
  description    = each.value.description
  ref            = each.value.ref
  active         = each.value.active
  cron_timezone  = each.value.cron_timezone
  take_ownership = each.value.take_ownership
}

resource "gitlab_pipeline_schedule_variable" "pipeline_schedule_variable" {
  for_each = merge([
    for schedule_name, data in local.all_schedules : {
      for variable_key, variable_data in coalesce(data.variables, {}) :
      "${schedule_name}_${variable_key}" => {
        schedule_name = schedule_name
        key           = variable_key
        value         = variable_data.value
        variable_type = variable_data.variable_type
      }
    }
  ]...)
  project              = var.project_id
  pipeline_schedule_id = gitlab_pipeline_schedule.pipeline_schedule[each.value.schedule_name].pipeline_schedule_id
  key                  = each.value.key
  value                = each.value.value
  variable_type        = each.value.variable_type
}
