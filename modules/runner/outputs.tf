output "runners" {
  description = "Map of created runners with their attributes"
  value = var.create_only ? {
    for key, runner in gitlab_user_runner.create_only_runner :
    key => {
      id               = runner.id
      runner_type      = runner.runner_type
      access_level     = runner.access_level
      description      = runner.description
      group_id         = runner.group_id
      locked           = runner.locked
      maintenance_note = runner.maintenance_note
      maximum_timeout  = runner.maximum_timeout
      paused           = runner.paused
      project_id       = runner.project_id
      tag_list         = runner.tag_list
      untagged         = runner.untagged
    }
    } : {
    for key, runner in gitlab_user_runner.runner :
    key => {
      id               = runner.id
      runner_type      = runner.runner_type
      access_level     = runner.access_level
      description      = runner.description
      group_id         = runner.group_id
      locked           = runner.locked
      maintenance_note = runner.maintenance_note
      maximum_timeout  = runner.maximum_timeout
      paused           = runner.paused
      project_id       = runner.project_id
      tag_list         = runner.tag_list
      untagged         = runner.untagged
    }
  }
}

output "runner_ids" {
  description = "Map of runner names to their IDs"
  value = var.create_only ? {
    for key, runner in gitlab_user_runner.create_only_runner :
    key => runner.id
    } : {
    for key, runner in gitlab_user_runner.runner :
    key => runner.id
  }
}

output "runner_tokens" {
  description = "Map of runner names to their authentication tokens"
  value = var.create_only ? {
    for key, runner in gitlab_user_runner.create_only_runner :
    key => runner.token
    } : {
    for key, runner in gitlab_user_runner.runner :
    key => runner.token
  }
  sensitive = true
}
