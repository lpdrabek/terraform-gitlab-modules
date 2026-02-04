terraform {
  required_version = ">= 1.6.0"
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 18.8.0, < 19.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0, < 4.0.0"
    }
  }
}

