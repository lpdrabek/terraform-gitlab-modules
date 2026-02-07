locals {
  yaml_content = try(yamldecode(file(var.runners_file)), {})

  runners_from_file = {
    for runner, config in local.yaml_content :
    runner => {
      runner_type      = config.runner_type
      access_level     = try(config.access_level, null)
      description      = try(config.description, null)
      group_id         = try(config.group_id, null)
      locked           = try(config.locked, null)
      maintenance_note = try(config.maintenance_note, null)
      maximum_timeout  = try(config.maximum_timeout, null)
      paused           = try(config.paused, null)
      project_id       = try(config.project_id, null)
      tag_list         = try(config.tag_list, null)
      untagged         = try(config.untagged, false)
    }
  }

  all_runners = merge(local.runners_from_file, var.runners)
}
