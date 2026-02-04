mock_provider "gitlab" {}

run "project_variable_basic" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    variables = {
      "MY_VAR" = {
        value = "my-value"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_variable.project_variables) == 1
    error_message = "Should create 1 project variable"
  }

  assert {
    condition     = length(gitlab_group_variable.group_variables) == 0
    error_message = "Should create 0 group variables"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["MY_VAR"].key == "MY_VAR"
    error_message = "Variable key should be 'MY_VAR'"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["MY_VAR"].project == "123"
    error_message = "Variable should be for project 123"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["MY_VAR"].value == "my-value"
    error_message = "Variable value should be 'my-value'"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["MY_VAR"].variable_type == "env_var"
    error_message = "Variable type should default to 'env_var'"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["MY_VAR"].protected == false
    error_message = "Variable should not be protected by default"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["MY_VAR"].masked == false
    error_message = "Variable should not be masked by default"
  }
}

run "group_variable_basic" {
  command = plan

  variables {
    target = {
      type = "group"
      id   = "456"
    }

    variables = {
      "GROUP_VAR" = {
        value       = "group-value"
        description = "This is a description"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_variable.project_variables) == 0
    error_message = "Should create 0 project variables"
  }

  assert {
    condition     = length(gitlab_group_variable.group_variables) == 1
    error_message = "Should create 1 group variable"
  }

  assert {
    condition     = gitlab_group_variable.group_variables["GROUP_VAR"].key == "GROUP_VAR"
    error_message = "Variable key should be 'GROUP_VAR'"
  }

  assert {
    condition     = gitlab_group_variable.group_variables["GROUP_VAR"].group == "456"
    error_message = "Variable should be for group 456"
  }

  assert {
    condition     = gitlab_group_variable.group_variables["GROUP_VAR"].value == "group-value"
    error_message = "Variable value should be 'group-value'"
  }

  assert {
    condition     = gitlab_group_variable.group_variables["GROUP_VAR"].description == "This is a description"
    error_message = "Variable should have the correct description"
  }
}

run "protected_variable" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    variables = {
      "PROTECTED_VAR" = {
        value     = "protected-value"
        protected = true
      }
    }
  }

  assert {
    condition     = gitlab_project_variable.project_variables["PROTECTED_VAR"].protected == true
    error_message = "Variable should be protected"
  }
}

run "masked_variable" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    variables = {
      "MASKED_VAR" = {
        value  = "12345678"
        masked = true
      }
    }
  }

  assert {
    condition     = gitlab_project_variable.project_variables["MASKED_VAR"].masked == true
    error_message = "Variable should be masked"
  }
}

run "file_variable" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    variables = {
      "CONFIG_FILE" = {
        value         = "config content"
        variable_type = "file"
      }
    }
  }

  assert {
    condition     = gitlab_project_variable.project_variables["CONFIG_FILE"].variable_type == "file"
    error_message = "Variable type should be 'file'"
  }
}

run "variable_with_environment_scope" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    variables = {
      "PROD_VAR" = {
        value             = "production-value"
        environment_scope = "production"
      }
      "STAGING_VAR" = {
        value             = "staging-value"
        environment_scope = "staging/*"
      }
      "ALL_VAR" = {
        value             = "all-value"
        environment_scope = "*"
      }
    }
  }

  assert {
    condition     = gitlab_project_variable.project_variables["PROD_VAR"].environment_scope == "production"
    error_message = "PROD_VAR environment_scope should be 'production'"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["STAGING_VAR"].environment_scope == "staging/*"
    error_message = "STAGING_VAR environment_scope should be 'staging/*'"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["ALL_VAR"].environment_scope == "*"
    error_message = "ALL_VAR environment_scope should be '*'"
  }
}

run "raw_variable" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    variables = {
      "RAW_VAR" = {
        value = "raw-value-with-$special"
        raw   = true
      }
    }
  }

  assert {
    condition     = gitlab_project_variable.project_variables["RAW_VAR"].raw == true
    error_message = "Variable should be raw"
  }
}

run "multiple_variables" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    variables = {
      "VAR_1" = {
        value       = "value-1"
        description = "var_1 description"
      }
      "VAR_2" = {
        value = "value-2"
      }
      "VAR_3" = {
        value = "value-3"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_variable.project_variables) == 3
    error_message = "Should create 3 project variables"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["VAR_1"].value == "value-1"
    error_message = "VAR_1 value should match"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["VAR_1"].description == "var_1 description"
    error_message = "VAR_3 value should match"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["VAR_2"].value == "value-2"
    error_message = "VAR_2 value should match"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["VAR_3"].value == "value-3"
    error_message = "VAR_3 value should match"
  }
}

run "empty_variables" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    variables = {}
  }

  assert {
    condition     = length(gitlab_project_variable.project_variables) == 0
    error_message = "Should create 0 project variables when variables is empty"
  }

  assert {
    condition     = length(gitlab_group_variable.group_variables) == 0
    error_message = "Should create 0 group variables when variables is empty"
  }
}

run "hidden_masked_variable" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "123"
    }

    variables = {
      "SECRET_VAR" = {
        value  = "12345678"
        masked = true
        hidden = true
      }
    }
  }

  assert {
    condition     = gitlab_project_variable.project_variables["SECRET_VAR"].hidden == true
    error_message = "Variable should be hidden"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["SECRET_VAR"].masked == true
    error_message = "Variable should be masked"
  }
}

run "complex_variable" {
  command = plan

  variables {
    target = {
      type = "project"
      id   = "789"
    }

    variables = {
      "COMPLEX_VAR" = {
        value             = "complex-value"
        description       = "A complex variable"
        environment_scope = "production"
        protected         = true
        masked            = false
        raw               = false
        variable_type     = "env_var"
      }
    }
  }

  assert {
    condition     = gitlab_project_variable.project_variables["COMPLEX_VAR"].value == "complex-value"
    error_message = "Variable value should match"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["COMPLEX_VAR"].description == "A complex variable"
    error_message = "Variable description should match"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["COMPLEX_VAR"].environment_scope == "production"
    error_message = "Variable environment_scope should match"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["COMPLEX_VAR"].protected == true
    error_message = "Variable should be protected"
  }

  assert {
    condition     = gitlab_project_variable.project_variables["COMPLEX_VAR"].variable_type == "env_var"
    error_message = "Variable type should be 'env_var'"
  }
}
