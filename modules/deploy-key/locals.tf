locals {
  deploy_keys_yaml = try(yamldecode(file(var.deploy_keys_file)), {})

  deploy_keys_from_file = {
    for name, key in local.deploy_keys_yaml :
    name => {
      key        = try(tostring(key.key), null)
      key_id     = try(tostring(key.key_id), null)
      can_push   = try(key.can_push, null)
      expires_at = try(key.expires_at, null)
      enable     = try(tolist(key.enable), null)
    }
  }

  all_deploy_keys = merge(local.deploy_keys_from_file, var.deploy_keys)

  create_keys = {
    for name, key in local.all_deploy_keys :
    name => key if key.key != null
  }

  enable_keys = {
    for pair in flatten([
      for name, key in local.all_deploy_keys : [
        for project in coalesce(key.enable, []) : {
          name     = name
          project  = project
          key_id   = key.key_id
          can_push = key.can_push
          created  = key.key != null
        }
      ]
    ]) : "${pair.name}:${pair.project}" => pair
  }
}
