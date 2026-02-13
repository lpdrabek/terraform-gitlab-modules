mock_provider "gitlab" {}

run "basic_file" {
  command = plan

  variables {
    project = "123"

    files = {
      "README.md" = {
        branch  = "main"
        content = "# My Project"
      }
    }
  }

  assert {
    condition     = length(gitlab_repository_file.file) == 1
    error_message = "Should create 1 repository file"
  }

  assert {
    condition     = gitlab_repository_file.file["README.md"].file_path == "README.md"
    error_message = "File path should be 'README.md'"
  }

  assert {
    condition     = gitlab_repository_file.file["README.md"].branch == "main"
    error_message = "Branch should be 'main'"
  }

  assert {
    condition     = gitlab_repository_file.file["README.md"].content == "# My Project"
    error_message = "Content should match"
  }

  assert {
    condition     = gitlab_repository_file.file["README.md"].project == "123"
    error_message = "File should belong to project '123'"
  }

  assert {
    condition     = gitlab_repository_file.file["README.md"].encoding == "text"
    error_message = "Default encoding should be 'text'"
  }

  assert {
    condition     = gitlab_repository_file.file["README.md"].commit_message == "Update README.md"
    error_message = "Default commit message should be 'Update README.md'"
  }
}

run "multiple_files" {
  command = plan

  variables {
    project = "456"

    files = {
      "README.md" = {
        branch  = "main"
        content = "# Project"
      }
      ".gitignore" = {
        branch  = "main"
        content = "*.log"
      }
      "docs/guide.md" = {
        branch  = "main"
        content = "# Guide"
      }
    }
  }

  assert {
    condition     = length(gitlab_repository_file.file) == 3
    error_message = "Should create 3 repository files"
  }

  assert {
    condition     = gitlab_repository_file.file["docs/guide.md"].file_path == "docs/guide.md"
    error_message = "Nested file path should be preserved"
  }
}

run "custom_commit_message" {
  command = plan

  variables {
    project = "123"

    files = {
      "config.json" = {
        branch         = "main"
        content        = "{}"
        commit_message = "Add configuration file"
      }
    }
  }

  assert {
    condition     = gitlab_repository_file.file["config.json"].commit_message == "Add configuration file"
    error_message = "Custom commit message should be used"
  }
}

run "specific_commit_messages" {
  command = plan

  variables {
    project = "123"

    files = {
      "setup.sh" = {
        branch                = "main"
        content               = "#!/bin/bash"
        create_commit_message = "Add setup script"
        update_commit_message = "Update setup script"
        delete_commit_message = "Remove setup script"
      }
    }
  }

  assert {
    condition     = gitlab_repository_file.file["setup.sh"].create_commit_message == "Add setup script"
    error_message = "Create commit message should be set"
  }

  assert {
    condition     = gitlab_repository_file.file["setup.sh"].update_commit_message == "Update setup script"
    error_message = "Update commit message should be set"
  }

  assert {
    condition     = gitlab_repository_file.file["setup.sh"].delete_commit_message == "Remove setup script"
    error_message = "Delete commit message should be set"
  }

  assert {
    condition     = gitlab_repository_file.file["setup.sh"].commit_message == null
    error_message = "commit_message should be null when specific messages are used"
  }
}

run "base64_encoding" {
  command = plan

  variables {
    project = "123"

    files = {
      "text.txt" = {
        branch   = "main"
        content  = "Qm9vbSwgcGhyYXNpbmc="
        encoding = "base64"
      }
    }
  }

  assert {
    condition     = gitlab_repository_file.file["text.txt"].encoding == "base64"
    error_message = "Encoding should be 'base64'"
  }
}

run "author_info" {
  command = plan

  variables {
    project = "123"

    files = {
      "file.txt" = {
        branch       = "main"
        content      = "content"
        author_name  = "Terraform"
        author_email = "terraform@example.com"
      }
    }
  }

  assert {
    condition     = gitlab_repository_file.file["file.txt"].author_name == "Terraform"
    error_message = "Author name should be set"
  }

  assert {
    condition     = gitlab_repository_file.file["file.txt"].author_email == "terraform@example.com"
    error_message = "Author email should be set"
  }
}

run "execute_filemode" {
  command = plan

  variables {
    project = "123"

    files = {
      "scripts/run.sh" = {
        branch           = "main"
        content          = "#!/bin/bash\necho hello"
        execute_filemode = true
      }
    }
  }

  assert {
    condition     = gitlab_repository_file.file["scripts/run.sh"].execute_filemode == true
    error_message = "Execute filemode should be true"
  }
}

run "start_branch" {
  command = plan

  variables {
    project = "123"

    files = {
      "new-feature.md" = {
        branch       = "feature/docs"
        start_branch = "main"
        content      = "# New Feature"
      }
    }
  }

  assert {
    condition     = gitlab_repository_file.file["new-feature.md"].branch == "feature/docs"
    error_message = "Branch should be 'feature/docs'"
  }

  assert {
    condition     = gitlab_repository_file.file["new-feature.md"].start_branch == "main"
    error_message = "Start branch should be 'main'"
  }
}

