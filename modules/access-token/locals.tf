locals {
  # Valid scopes for each token type
  personal_scopes = toset([
    "api", "read_user", "read_api", "read_repository", "write_repository",
    "read_registry", "write_registry", "read_virtual_registry", "write_virtual_registry",
    "sudo", "admin_mode", "create_runner", "manage_runner", "ai_features",
    "k8s_proxy", "self_rotate", "read_service_ping"
  ])
  group_scopes = toset([
    "api", "read_api", "read_registry", "write_registry",
    "read_virtual_registry", "write_virtual_registry", "read_repository", "write_repository",
    "create_runner", "manage_runner", "ai_features", "k8s_proxy",
    "read_observability", "write_observability", "self_rotate"
  ])
  project_scopes = toset([
    "api", "read_api", "read_registry", "write_registry",
    "read_repository", "write_repository", "create_runner", "manage_runner",
    "ai_features", "k8s_proxy", "read_observability", "write_observability", "self_rotate"
  ])

  # Load tokens from YAML file
  yaml_content = try(yamldecode(file(var.access_tokens_file)), {})

  tokens_from_file = {
    for name, token in local.yaml_content :
    name => {
      scopes                        = token.scopes
      access_level                  = try(token.access_level, "maintainer")
      description                   = try(token.description, null)
      expires_at                    = token.expires_at # Required field, no default
      validate_past_expiration_date = try(token.validate_past_expiration_date, null)
      # rotation_configuration        = try(token.rotation_configuration, null) # TODO?
    }
  }

  all_tokens = merge(local.tokens_from_file, var.access_tokens)

  tokens_missing_expiry = [
    for name, token in local.all_tokens :
    name if token.expires_at == null
  ]

  valid_scopes = var.target.type == "personal" ? local.personal_scopes : (
    var.target.type == "group" ? local.group_scopes : local.project_scopes
  )
  invalid_scopes = flatten([
    for token_name, token in local.all_tokens : [
      for scope in token.scopes :
      scope if !contains(local.valid_scopes, scope) # if scope is not found in valid scopes for that target add to this local
    ]
  ])
  scopes_are_valid = length(local.invalid_scopes) == 0 # Used in preconditions, if it's 0 we didn't find invalid scopes
}
