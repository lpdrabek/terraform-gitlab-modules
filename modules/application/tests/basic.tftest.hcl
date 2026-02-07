mock_provider "gitlab" {}

run "basic_application" {
  command = plan

  variables {
    applications = {
      "my-app" = {
        redirect_url = "https://myapp.example.com/callback"
        scopes       = ["api", "read_user"]
        confidential = true
      }
    }
  }

  assert {
    condition     = length(gitlab_application.application) == 1
    error_message = "Should create 1 application"
  }

  assert {
    condition     = gitlab_application.application["my-app"].name == "my-app"
    error_message = "Application name should be 'my-app'"
  }

  assert {
    condition     = gitlab_application.application["my-app"].redirect_url == "https://myapp.example.com/callback"
    error_message = "Application redirect_url should match"
  }

  assert {
    condition     = contains(gitlab_application.application["my-app"].scopes, "api")
    error_message = "Application scopes should contain 'api'"
  }

  assert {
    condition     = contains(gitlab_application.application["my-app"].scopes, "read_user")
    error_message = "Application scopes should contain 'read_user'"
  }

  assert {
    condition     = gitlab_application.application["my-app"].confidential == true
    error_message = "Application should be confidential"
  }
}

run "non_confidential_application" {
  command = plan

  variables {
    applications = {
      "public" = {
        redirect_url = "https://app1.example.com/callback"
        scopes       = ["read_api", "openid", "profile"]
        confidential = false
      }
    }
  }

  assert {
    condition     = gitlab_application.application["public"].confidential == false
    error_message = "Application should not be confidential"
  }

  assert {
    condition     = contains(gitlab_application.application["public"].scopes, "openid")
    error_message = "Application scopes should contain 'openid'"
  }
}

run "default_confidential" {
  command = plan

  variables {
    applications = {
      "default-app" = {
        redirect_url = "https://default.example.com/callback"
        scopes       = ["api"]
      }
    }
  }

  assert {
    condition     = gitlab_application.application["default-app"].confidential == true
    error_message = "Application should default to confidential"
  }
}

run "multiple_applications" {
  command = plan

  variables {
    applications = {
      "grafana" = {
        redirect_url = "https://grafana.example.com/login/gitlab"
        scopes       = ["api", "read_user", "openid", "profile", "email"]
        confidential = true
      }
      "argocd" = {
        redirect_url = "https://argocd.example.com/api/dex/callback"
        scopes       = ["read_api", "openid", "profile", "email"]
        confidential = true
      }
      "public-dashboard" = {
        redirect_url = "https://dashboard.example.com/oauth/callback"
        scopes       = ["read_api", "openid", "profile"]
        confidential = false
      }
    }
  }

  assert {
    condition     = length(gitlab_application.application) == 3
    error_message = "Should create 3 applications"
  }

  assert {
    condition     = gitlab_application.application["grafana"].name == "grafana"
    error_message = "Grafana application name should match"
  }

  assert {
    condition     = gitlab_application.application["argocd"].name == "argocd"
    error_message = "ArgoCD application name should match"
  }

  assert {
    condition     = gitlab_application.application["public-dashboard"].confidential == false
    error_message = "Public dashboard should not be confidential"
  }
}

run "empty_applications" {
  command = plan

  variables {
    applications = {}
  }

  assert {
    condition     = length(gitlab_application.application) == 0
    error_message = "Should create 0 applications when empty"
  }
}

run "oidc_application" {
  command = plan

  variables {
    applications = {
      "vault" = {
        redirect_url = "https://vault.example.com/ui/vault/auth/oidc/oidc/callback"
        scopes       = ["openid", "profile", "email", "read_user"]
        confidential = true
      }
    }
  }

  assert {
    condition     = contains(gitlab_application.application["vault"].scopes, "openid")
    error_message = "OIDC application should have openid scope"
  }

  assert {
    condition     = contains(gitlab_application.application["vault"].scopes, "profile")
    error_message = "OIDC application should have profile scope"
  }

  assert {
    condition     = contains(gitlab_application.application["vault"].scopes, "email")
    error_message = "OIDC application should have email scope"
  }
}
