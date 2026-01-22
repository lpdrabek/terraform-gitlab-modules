terraform {
  required_version = ">= 1.6.0"
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 18.0.0, < 19.0.0"
    }
  }
}

provider "gitlab" {
  base_url = var.gitlab_base_url
  token    = var.gitlab_token
}

variable "gitlab_base_url" {
  description = "GitLab instance URL"
  type        = string
  default     = "https://gitlab.com"
}

variable "gitlab_token" {
  description = "GitLab API token"
  type        = string
  sensitive   = true
}

data "gitlab_project" "main_project" {
  path_with_namespace = "tf-tests/testing-project"
}
