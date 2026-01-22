mock_provider "gitlab" {}
mock_provider "random" {}

run "basic_project" {
  command = plan

  variables {
    projects = {
      "my-project" = {}
    }
  }

  assert {
    condition     = length(gitlab_project.projects) == 1
    error_message = "Should create 1 project"
  }

  assert {
    condition     = length(gitlab_project.create_only_projects) == 0
    error_message = "Should create 0 create_only projects"
  }

  assert {
    condition     = gitlab_project.projects["my-project"].name == "my-project"
    error_message = "Project name should be 'my-project'"
  }

  assert {
    condition     = gitlab_project.projects["my-project"].visibility_level == "private"
    error_message = "visibility_level should default to 'private'"
  }

  assert {
    condition     = length(gitlab_pipeline_trigger.pipeline_trigger) == 0
    error_message = "Should not create 'gitlab_pipeline_trigger'"
  }
}

run "project_with_description" {
  command = plan

  variables {
    projects = {
      "described-project" = {
        description = "A project with a description"
      }
    }
  }

  assert {
    condition     = gitlab_project.projects["described-project"].description == "A project with a description"
    error_message = "Project description should match"
  }
}

run "project_with_visibility" {
  command = plan

  variables {
    projects = {
      "public-project" = {
        visibility_level = "public"
      }
      "internal-project" = {
        visibility_level = "internal"
      }
      "private-project" = {
        visibility_level = "private"
      }
    }
  }

  assert {
    condition     = length(gitlab_project.projects) == 3
    error_message = "Should create 3 projects"
  }

  assert {
    condition     = gitlab_project.projects["public-project"].visibility_level == "public"
    error_message = "public-project visibility should be 'public'"
  }

  assert {
    condition     = gitlab_project.projects["internal-project"].visibility_level == "internal"
    error_message = "internal-project visibility should be 'internal'"
  }

  assert {
    condition     = gitlab_project.projects["private-project"].visibility_level == "private"
    error_message = "private-project visibility should be 'private'"
  }
}

run "project_with_path" {
  command = plan

  variables {
    projects = {
      "My Project" = {
        path = "my-custom-path"
      }
    }
  }

  assert {
    condition     = gitlab_project.projects["My Project"].name == "My Project"
    error_message = "Project name should be 'My Project'"
  }

  assert {
    condition     = gitlab_project.projects["My Project"].path == "my-custom-path"
    error_message = "Project path should be 'my-custom-path'"
  }
}

run "project_with_readme" {
  command = plan

  variables {
    projects = {
      "readme-project" = {
        initialize_with_readme = true
      }
    }
  }

  assert {
    condition     = gitlab_project.projects["readme-project"].initialize_with_readme == true
    error_message = "Project should be initialized with readme"
  }
}

run "project_with_merge_settings" {
  command = plan

  variables {
    projects = {
      "strict-project" = {
        merge_method                                     = "ff"
        squash_option                                    = "always"
        only_allow_merge_if_pipeline_succeeds            = true
        only_allow_merge_if_all_discussions_are_resolved = true
        remove_source_branch_after_merge                 = true
      }
    }
  }

  assert {
    condition     = gitlab_project.projects["strict-project"].merge_method == "ff"
    error_message = "merge_method should be 'ff'"
  }

  assert {
    condition     = gitlab_project.projects["strict-project"].squash_option == "always"
    error_message = "squash_option should be 'always'"
  }

  assert {
    condition     = gitlab_project.projects["strict-project"].only_allow_merge_if_pipeline_succeeds == true
    error_message = "only_allow_merge_if_pipeline_succeeds should be true"
  }

  assert {
    condition     = gitlab_project.projects["strict-project"].only_allow_merge_if_all_discussions_are_resolved == true
    error_message = "only_allow_merge_if_all_discussions_are_resolved should be true"
  }

  assert {
    condition     = gitlab_project.projects["strict-project"].remove_source_branch_after_merge == true
    error_message = "remove_source_branch_after_merge should be true"
  }
}

run "project_with_cicd_settings" {
  command = plan

  variables {
    projects = {
      "cicd-project" = {
        ci_config_path         = ".gitlab/ci/main.yml"
        ci_default_git_depth   = 50
        shared_runners_enabled = false
        build_timeout          = 7200
        build_git_strategy     = "clone"
      }
    }
  }

  assert {
    condition     = gitlab_project.projects["cicd-project"].ci_config_path == ".gitlab/ci/main.yml"
    error_message = "ci_config_path should match"
  }

  assert {
    condition     = gitlab_project.projects["cicd-project"].ci_default_git_depth == 50
    error_message = "ci_default_git_depth should be 50"
  }

  assert {
    condition     = gitlab_project.projects["cicd-project"].shared_runners_enabled == false
    error_message = "shared_runners_enabled should be false"
  }

  assert {
    condition     = gitlab_project.projects["cicd-project"].build_timeout == 7200
    error_message = "build_timeout should be 7200"
  }

  assert {
    condition     = gitlab_project.projects["cicd-project"].build_git_strategy == "clone"
    error_message = "build_git_strategy should be 'clone'"
  }
}

run "project_with_access_levels" {
  command = plan

  variables {
    projects = {
      "access-project" = {
        issues_access_level         = "private"
        merge_requests_access_level = "enabled"
        wiki_access_level           = "disabled"
        builds_access_level         = "private"
        snippets_access_level       = "disabled"
      }
    }
  }

  assert {
    condition     = gitlab_project.projects["access-project"].issues_access_level == "private"
    error_message = "issues_access_level should be 'private'"
  }

  assert {
    condition     = gitlab_project.projects["access-project"].merge_requests_access_level == "enabled"
    error_message = "merge_requests_access_level should be 'enabled'"
  }

  assert {
    condition     = gitlab_project.projects["access-project"].wiki_access_level == "disabled"
    error_message = "wiki_access_level should be 'disabled'"
  }

  assert {
    condition     = gitlab_project.projects["access-project"].builds_access_level == "private"
    error_message = "builds_access_level should be 'private'"
  }

  assert {
    condition     = gitlab_project.projects["access-project"].snippets_access_level == "disabled"
    error_message = "snippets_access_level should be 'disabled'"
  }
}

run "project_with_topics" {
  command = plan

  variables {
    projects = {
      "tagged-project" = {
        topics = ["terraform", "gitlab", "automation"]
      }
    }
  }

  assert {
    condition     = contains(gitlab_project.projects["tagged-project"].topics, "terraform")
    error_message = "Project should have 'terraform' topic"
  }

  assert {
    condition     = contains(gitlab_project.projects["tagged-project"].topics, "gitlab")
    error_message = "Project should have 'gitlab' topic"
  }

  assert {
    condition     = contains(gitlab_project.projects["tagged-project"].topics, "automation")
    error_message = "Project should have 'automation' topic"
  }
}

run "project_archived" {
  command = plan

  variables {
    projects = {
      "archived-project" = {
        archived           = true
        archive_on_destroy = true
      }
    }
  }

  assert {
    condition     = gitlab_project.projects["archived-project"].archived == true
    error_message = "Project should be archived"
  }

  assert {
    condition     = gitlab_project.projects["archived-project"].archive_on_destroy == true
    error_message = "Project should have archive_on_destroy set to true"
  }
}

run "project_with_security" {
  command = plan

  variables {
    projects = {
      "secure-project" = {
        lfs_enabled                          = false
        pre_receive_secret_detection_enabled = true
      }
    }
  }

  assert {
    condition     = gitlab_project.projects["secure-project"].lfs_enabled == false
    error_message = "lfs_enabled should be false"
  }

  assert {
    condition     = gitlab_project.projects["secure-project"].pre_receive_secret_detection_enabled == true
    error_message = "pre_receive_secret_detection_enabled should be true"
  }
}

run "create_only_project" {
  command = plan

  variables {
    create_only = true

    projects = {
      "create-only-project" = {
        description      = "A create-only project"
        visibility_level = "internal"
      }
    }
  }

  assert {
    condition     = length(gitlab_project.projects) == 0
    error_message = "Should create 0 normal projects"
  }

  assert {
    condition     = length(gitlab_project.create_only_projects) == 1
    error_message = "Should create 1 create_only project"
  }

  assert {
    condition     = gitlab_project.create_only_projects["create-only-project"].name == "create-only-project"
    error_message = "create_only project name should match"
  }

  assert {
    condition     = gitlab_project.create_only_projects["create-only-project"].visibility_level == "internal"
    error_message = "create_only project visibility should be 'internal'"
  }
}

run "multiple_projects" {
  command = plan

  variables {
    projects = {
      "project-1" = {
        description = "First project"
      }
      "project-2" = {
        description = "Second project"
      }
      "project-3" = {
        description = "Third project"
      }
    }
  }

  assert {
    condition     = length(gitlab_project.projects) == 3
    error_message = "Should create 3 projects"
  }

  assert {
    condition     = gitlab_project.projects["project-1"].description == "First project"
    error_message = "project-1 description should match"
  }

  assert {
    condition     = gitlab_project.projects["project-2"].description == "Second project"
    error_message = "project-2 description should match"
  }

  assert {
    condition     = gitlab_project.projects["project-3"].description == "Third project"
    error_message = "project-3 description should match"
  }
}

run "empty_projects" {
  command = plan

  variables {
    projects = {}
  }

  assert {
    condition     = length(gitlab_project.projects) == 0
    error_message = "Should create 0 projects when projects is empty"
  }

  assert {
    condition     = length(gitlab_project.create_only_projects) == 0
    error_message = "Should create 0 create_only projects when projects is empty"
  }
}

run "project_default_values" {
  command = plan

  variables {
    projects = {
      "defaults-project" = {}
    }
  }

  assert {
    condition     = gitlab_project.projects["defaults-project"].visibility_level == "private"
    error_message = "Default visibility_level should be 'private'"
  }

  assert {
    condition     = gitlab_project.projects["defaults-project"].initialize_with_readme == false
    error_message = "Default initialize_with_readme should be false"
  }

  assert {
    condition     = gitlab_project.projects["defaults-project"].shared_runners_enabled == true
    error_message = "Default shared_runners_enabled should be true"
  }

  assert {
    condition     = gitlab_project.projects["defaults-project"].merge_method == "merge"
    error_message = "Default merge_method should be 'merge'"
  }

  assert {
    condition     = gitlab_project.projects["defaults-project"].squash_option == "default_off"
    error_message = "Default squash_option should be 'default_off'"
  }

  assert {
    condition     = gitlab_project.projects["defaults-project"].lfs_enabled == true
    error_message = "Default lfs_enabled should be true"
  }

  assert {
    condition     = gitlab_project.projects["defaults-project"].build_timeout == 3600
    error_message = "Default build_timeout should be 3600"
  }

  assert {
    condition     = gitlab_project.projects["defaults-project"].build_git_strategy == "fetch"
    error_message = "Default build_git_strategy should be 'fetch'"
  }
}

run "project_with_pipeline_trigger" {
  command = plan

  variables {
    projects = {
      "trigger" = {
        pipeline_trigger = "trigger"
      }
    }
  }

  assert {
    condition     = gitlab_pipeline_trigger.pipeline_trigger["trigger"].description == "trigger"
    error_message = "Trigger description should be \"trigger\""
  }
}