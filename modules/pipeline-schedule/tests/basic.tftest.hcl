mock_provider "gitlab" {}

run "schedules_minimal" {
  command = plan

  variables {
    project_id = "123"

    schedules = {
      "schedule1" = {
        cron  = "0 2 * * *"
        description = "schedule description, visible in Gitlab"
        ref = "refs/heads/master"
      }
    }
  }

  assert {
    condition     = length(gitlab_pipeline_schedule.pipeline_schedule) == 1
    error_message = "Should create 1 project schedule"
  }
  assert {
    condition     = length(gitlab_pipeline_schedule_variable.pipeline_schedule_variable) == 0
    error_message = "Should create 0 project schedule vars"
  }

  assert {
    condition     = gitlab_pipeline_schedule.pipeline_schedule["schedule1"].cron == "0 2 * * *"
    error_message = "cron is should be \"0 2 * * *\""
  }
  assert {
    condition     = gitlab_pipeline_schedule.pipeline_schedule["schedule1"].description == "schedule description, visible in Gitlab"
    error_message = "description should be \"schedule description, visible in Gitlab\""
  }
  assert {
    condition     = gitlab_pipeline_schedule.pipeline_schedule["schedule1"].ref == "refs/heads/master"
    error_message = "ref should be \"refs/heads/master\""
  }
  assert {
    condition     = gitlab_pipeline_schedule.pipeline_schedule["schedule1"].project == "123"
    error_message = "schedule should be in project 123"
  }
}

run "schedule_with_var" {
  command = plan

  variables {
    project_id = "234"

    schedules = {
      "schedule1" = {
        cron  = "2 0 * * *"
        description = "schedule description"
        ref = "refs/heads/develop"
        variables = {
          "var1" = {
            value = "var1_val"
          }
        }
      }
    }
  }

  assert {
    condition     = length(gitlab_pipeline_schedule.pipeline_schedule) == 1
    error_message = "Should create 1 project schedule"
  }
  assert {
    condition     = length(gitlab_pipeline_schedule_variable.pipeline_schedule_variable) == 1
    error_message = "Should create 1 project schedule vars"
  }

  assert {
    condition     = gitlab_pipeline_schedule.pipeline_schedule["schedule1"].cron == "2 0 * * *"
    error_message = "cron is should be \"2 0 * * *\""
  }
  assert {
    condition     = gitlab_pipeline_schedule.pipeline_schedule["schedule1"].description == "schedule description"
    error_message = "description should be \"schedule description\""
  }
  assert {
    condition     = gitlab_pipeline_schedule.pipeline_schedule["schedule1"].ref == "refs/heads/develop"
    error_message = "ref should be \"refs/heads/develop\""
  }
  assert {
    condition     = gitlab_pipeline_schedule.pipeline_schedule["schedule1"].project == "234"
    error_message = "schedule should be in project 234"
  }

  assert {
    condition     = gitlab_pipeline_schedule_variable.pipeline_schedule_variable["schedule1_var1"].project == "234"
    error_message = "Variable should be in project \"234\""
  }
  assert {
    condition     = gitlab_pipeline_schedule_variable.pipeline_schedule_variable["schedule1_var1"].key == "var1"
    error_message = "Key of the variable should be should be in project \"var1\""
  }
  assert {
    condition     = gitlab_pipeline_schedule_variable.pipeline_schedule_variable["schedule1_var1"].value == "var1_val"
    error_message = "Value of the variable should be should be in project \"var1_val\""
  }
}

run "schedules_with_vars" {
  command = plan

  variables {
    project_id = "345"

    schedules = {
      "schedule1" = {
        cron  = "* * * * *"
        description = "schedule description"
        ref = "refs/heads/develop"
        cron_timezone = "UTC"
        take_ownership = false
        variables = {
          "var1" = {
            value = "var1_val"
          }
          "var2" = {
            value = "var2_val"
            variable_type = "file"
          }
        }
      }
    }
  }

  assert {
    condition     = length(gitlab_pipeline_schedule.pipeline_schedule) == 1
    error_message = "Should create 1 project schedule"
  }
  assert {
    condition     = length(gitlab_pipeline_schedule_variable.pipeline_schedule_variable) == 2
    error_message = "Should create 2 project schedule vars"
  }

  assert {
    condition     = gitlab_pipeline_schedule.pipeline_schedule["schedule1"].cron == "* * * * *" 
    error_message = "cron is should be \"* * * * *\""
  }
  assert {
    condition     = gitlab_pipeline_schedule.pipeline_schedule["schedule1"].description == "schedule description"
    error_message = "description should be \"schedule description\""
  }
  assert {
    condition     = gitlab_pipeline_schedule.pipeline_schedule["schedule1"].ref == "refs/heads/develop"
    error_message = "ref should be \"refs/heads/develop\""
  }
  assert {
    condition     = gitlab_pipeline_schedule.pipeline_schedule["schedule1"].project == "345"
    error_message = "schedule should be in project 345"
  }

  assert {
    condition     = gitlab_pipeline_schedule_variable.pipeline_schedule_variable["schedule1_var1"].project == "345"
    error_message = "Variable should be in project \"345\""
  }
  assert {
    condition     = gitlab_pipeline_schedule_variable.pipeline_schedule_variable["schedule1_var1"].key == "var1"
    error_message = "Key of the variable should be should be in project \"var1\""
  }
  assert {
    condition     = gitlab_pipeline_schedule_variable.pipeline_schedule_variable["schedule1_var1"].value == "var1_val"
    error_message = "Value of the variable should be should be in project \"var1_val\""
  }
  assert {
    condition     = gitlab_pipeline_schedule_variable.pipeline_schedule_variable["schedule1_var1"].value == "var1_val"
    error_message = "Value of the variable should be should be in project \"var1_val\""
  }
  assert {
    condition     = gitlab_pipeline_schedule_variable.pipeline_schedule_variable["schedule1_var1"].variable_type == "env_var"
    error_message = "Value of the variable_type should be should be in project \"env_var\""
  }

  assert {
    condition     = gitlab_pipeline_schedule_variable.pipeline_schedule_variable["schedule1_var2"].project == "345"
    error_message = "Variable should be in project \"345\""
  }
  assert {
    condition     = gitlab_pipeline_schedule_variable.pipeline_schedule_variable["schedule1_var2"].key == "var2"
    error_message = "Key of the variable should be should be in project \"var1\""
  }
  assert {
    condition     = gitlab_pipeline_schedule_variable.pipeline_schedule_variable["schedule1_var2"].value == "var2_val"
    error_message = "Value of the variable should be should be in project \"var1_val\""
  }
  assert {
    condition     = gitlab_pipeline_schedule_variable.pipeline_schedule_variable["schedule1_var2"].value == "var2_val"
    error_message = "Value of the variable should be should be in project \"var1_val\""
  }
  assert {
    condition     = gitlab_pipeline_schedule_variable.pipeline_schedule_variable["schedule1_var2"].variable_type == "file"
    error_message = "Value of the variable_type should be should be in project \"env_var\""
  }
}
