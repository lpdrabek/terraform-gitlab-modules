locals {
  yaml_content = try(yamldecode(file(var.applications_file)), {})

  applications_from_file = {
    for key, app in local.yaml_content :
    key => {
      redirect_url = app.redirect_url
      scopes       = toset(app.scopes)
      confidential = try(app.confidential, true)
    }
  }

  all_applications = merge(local.applications_from_file, var.applications)
}
