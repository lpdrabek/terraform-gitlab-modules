module "project_variables" {
  source = "../../modules/variables"

  target = {
    type = "project"
    id   = data.gitlab_project.main_project.id
  }

  variables = {
    DEPLOY_ENV = {
      value             = "staging"
      description       = "Deployment environment"
      environment_scope = "staging/*"
    }
    API_KEY = {
      value       = "secret-key-value"
      description = "API key for external service"
      masked      = true
      protected   = true
    }
    RAW_VALUE = {
      value       = "$${NOT_EXPANDED}"
      description = "Raw variable without expansion"
      raw         = true
    }
    CONFIG_FILE = {
      value         = <<-EOT
        setting1: value1
        setting2: value2
      EOT
      description   = "Configuration file content"
      variable_type = "file"
    }
    HIDDEN_VAR = {
      value       = "hidden-value-here"
      description = "Hidden variable - not visible in UI"
      hidden      = true
      masked      = true # hidden requires masked
    }
    PROD_API_KEY = {
      value             = "production-secret-key"
      description       = "Production API key"
      masked            = true
      protected         = true
      environment_scope = "production"
    }
  }

  variables_file = "${path.module}/variables.yml"
}

output "project_variables" {
  description = "Created project variables (sensitive)"
  value       = module.project_variables.variables
  sensitive   = true
}

module "group_variables" {
  source = "../../modules/variables"

  target = {
    type = "group"
    id   = data.gitlab_group.main_group.id
  }

  variables = {
    SHARED_SECRET = {
      value       = "group-wide-secret"
      description = "Shared secret for all projects in group"
      masked      = true
      protected   = true
    }
    DEFAULT_REGION = {
      value       = "eu-west-1"
      description = "Default deployment region"
    }
  }
}
