module "applications" {
  source = "../../modules/application"

  applications = {
    # -------------------------------------------------------------------------
    # Grafana - GitLab as OIDC provider
    # -------------------------------------------------------------------------
    "grafana" = {
      redirect_url = "https://grafana.example.com/login/gitlab"
      scopes       = ["api", "read_user", "openid", "profile", "email"]
      confidential = true
    }

    # -------------------------------------------------------------------------
    # ArgoCD - GitLab as OIDC provider for Kubernetes GitOps
    # -------------------------------------------------------------------------
    "argocd" = {
      redirect_url = "https://argocd.example.com/api/dex/callback"
      scopes       = ["read_api", "openid", "profile", "email"]
      confidential = true
    }

    # -------------------------------------------------------------------------
    # Public SPA - Non-confidential application for browser-based apps
    # -------------------------------------------------------------------------
    "public-dashboard" = {
      redirect_url = "https://dashboard.example.com/oauth/callback"
      scopes       = ["read_api", "openid", "profile"]
      confidential = false
    }
  }

  # Also load applications from YAML file
  applications_file = "${path.module}/applications.yml"
}

# =============================================================================
# Outputs
# =============================================================================

output "applications" {
  description = "Created applications (non-sensitive info)"
  value       = module.applications.applications
}

output "application_ids" {
  description = "Map of application names to IDs"
  value       = module.applications.application_ids
}

output "application_credentials" {
  description = "Application credentials for OAuth configuration"
  value       = module.applications.application_credentials
  sensitive   = true
}
