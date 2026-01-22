output "pipeline_schedules" {
  description = "Map of created pipeline schedules"
  value       = gitlab_pipeline_schedule.pipeline_schedule
}

output "pipeline_schedule_variables" {
  description = "Map of created pipeline schedule variables"
  value       = gitlab_pipeline_schedule_variable.pipeline_schedule_variable
  sensitive   = true
}
