locals {
  valid_scopes = toset([
    "read_repository", "read_registry", "write_registry",
    "read_virtual_registry", "write_virtual_registry",
    "read_package_registry", "write_package_registry"
  ])

  yaml_content = try(yamldecode(file(var.tokens_file)), {})

  tokens_from_file = {
    for name, token in local.yaml_content :
    name => {
      scopes                        = token.scopes
      username                      = try(token.username, null)
      expires_at                    = try(token.expires_at, null)
      validate_past_expiration_date = try(token.validate_past_expiration_date, null)
    }
  }

  all_tokens = merge(local.tokens_from_file, var.tokens)

  invalid_scopes = flatten([
    for token_name, token in local.all_tokens : [
      for scope in token.scopes :
      scope if !contains(local.valid_scopes, scope)
    ]
  ])
  scopes_are_valid = length(local.invalid_scopes) == 0
}
