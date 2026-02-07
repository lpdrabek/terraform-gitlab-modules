output "applications" {
  description = "Map of created applications with their attributes"
  value = {
    for key, app in gitlab_application.application :
    key => {
      id             = app.id
      application_id = app.application_id
      name           = app.name
      redirect_url   = app.redirect_url
      scopes         = app.scopes
      confidential   = app.confidential
    }
  }
}

output "application_ids" {
  description = "Map of application names to their IDs"
  value = {
    for key, app in gitlab_application.application :
    key => app.id
  }
}

output "application_credentials" {
  description = "Map of application names to their credentials (application_id and secret)"
  value = {
    for key, app in gitlab_application.application :
    key => {
      application_id = app.application_id
      secret         = app.secret
    }
  }
  sensitive = true
}
