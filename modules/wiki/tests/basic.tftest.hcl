mock_provider "gitlab" {}

run "basic_wiki_page" {
  command = plan

  variables {
    project_id = "123"

    pages = {
      "getting-started" = {
        title   = "Getting Started"
        content = "Welcome to the project wiki."
        format  = "markdown"
      }
    }
  }

  assert {
    condition     = length(gitlab_project_wiki_page.pages) == 1
    error_message = "Should create 1 wiki page"
  }

  assert {
    condition     = length(gitlab_project_wiki_page.create_only_pages) == 0
    error_message = "Should create 0 create_only wiki pages"
  }

  assert {
    condition     = gitlab_project_wiki_page.pages["getting-started"].title == "Getting Started"
    error_message = "Wiki page title should be 'Getting Started'"
  }

  assert {
    condition     = gitlab_project_wiki_page.pages["getting-started"].content == "Welcome to the project wiki."
    error_message = "Wiki page content should match"
  }

  assert {
    condition     = gitlab_project_wiki_page.pages["getting-started"].format == "markdown"
    error_message = "Wiki page format should be 'markdown'"
  }

  assert {
    condition     = gitlab_project_wiki_page.pages["getting-started"].project == "123"
    error_message = "Wiki page should be for project 123"
  }
}

run "title_from_key" {
  command = plan

  variables {
    project_id = "123"

    pages = {
      "my-wiki-page" = {
        content = "Content without explicit title."
      }
    }
  }

  assert {
    condition     = gitlab_project_wiki_page.pages["my-wiki-page"].title == "my wiki page"
    error_message = "Title should be derived from key with dashes replaced by spaces"
  }
}

run "multiple_pages" {
  command = plan

  variables {
    project_id = "123"

    pages = {
      "home" = {
        title   = "Home"
        content = "Main wiki page."
      }
      "faq" = {
        title   = "FAQ"
        content = "Frequently asked questions."
      }
      "changelog" = {
        title   = "Changelog"
        content = "Version history."
      }
    }
  }

  assert {
    condition     = length(gitlab_project_wiki_page.pages) == 3
    error_message = "Should create 3 wiki pages"
  }
}

run "create_only_mode" {
  command = plan

  variables {
    project_id  = "123"
    create_only = true

    pages = {
      "setup" = {
        title   = "Setup Guide"
        content = "Initial setup instructions."
      }
    }
  }

  assert {
    condition     = length(gitlab_project_wiki_page.pages) == 0
    error_message = "Should create 0 normal wiki pages"
  }

  assert {
    condition     = length(gitlab_project_wiki_page.create_only_pages) == 1
    error_message = "Should create 1 create_only wiki page"
  }

  assert {
    condition     = gitlab_project_wiki_page.create_only_pages["setup"].title == "Setup Guide"
    error_message = "Create-only wiki page title should match"
  }
}

run "empty_pages" {
  command = plan

  variables {
    project_id = "123"
    pages      = {}
  }

  assert {
    condition     = length(gitlab_project_wiki_page.pages) == 0
    error_message = "Should create 0 wiki pages when pages is empty"
  }

  assert {
    condition     = length(gitlab_project_wiki_page.create_only_pages) == 0
    error_message = "Should create 0 create_only wiki pages when pages is empty"
  }
}

run "rdoc_format" {
  command = plan

  variables {
    project_id = "123"

    pages = {
      "rdoc-page" = {
        title   = "RDoc Page"
        content = "Content in rdoc format."
        format  = "rdoc"
      }
    }
  }

  assert {
    condition     = gitlab_project_wiki_page.pages["rdoc-page"].format == "rdoc"
    error_message = "Wiki page format should be 'rdoc'"
  }
}
