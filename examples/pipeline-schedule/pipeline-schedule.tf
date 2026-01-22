module "pipeline_schedules" {
  source = "../../modules/pipeline-schedule"

  project_id = data.gitlab_project.main_project.id

  schedules = {
    nightly_build = {
      cron           = "0 2 * * *"
      description    = "Nightly build and test"
      ref            = "refs/heads/master"
      active         = true
      take_ownership = true
      variables = {
        DEPLOY_ENV = {
          value = "staging"
        }
        DEBUG = {
          value = "true"
        }
      }
    }
    weekly_cleanup = {
      cron           = "0 4 * * 0"
      description    = "Weekly cleanup job"
      ref            = "refs/heads/master"
      active         = true
      cron_timezone  = "Europe/London"
      take_ownership = true
      variables = {
        CLEANUP_DAYS = {
          value = "30"
        }
      }
    }
    monthly_report = {
      cron        = "0 6 1 * *"
      description = "Monthly report generation"
      ref         = "refs/heads/master"
      active      = false
    }
  }

  schedules_file = "${path.module}/schedules.yml"
}

output "pipeline_schedules" {
  description = "Created pipeline schedules"
  value       = module.pipeline_schedules
}
