# Note: Many issue board features require GitLab Premium/Ultimate
# - Multiple boards per project/group: Premium
# - Board scoping (labels, assignee, milestone, weight): Premium
# - Lists with assignee_id, iteration_id, milestone_id: Premium
# - Label-based lists should work on Free tier

module "project_boards" {
  source = "../../modules/issue_board"

  target = {
    type = "project"
    id   = data.gitlab_project.main_project.id
  }

  # Basic boards (Free tier)
  boards = {
    "Development" = {}
    "QA Testing"  = {}
  }

  boards_file = "${path.module}/boards.yml"
}

# Group boards require Owner role or GitLab Premium
# Uncomment if you have the required permissions
# module "group_boards" {
#   source = "../../modules/issue_board"
#
#   target = {
#     type = "group"
#     id   = data.gitlab_group.main_group.id
#   }
#
#   boards = {
#     "Group Overview" = {}
#   }
# }

# Uncomment below if you have GitLab Premium/Ultimate
# module "project_boards_premium" {
#   source = "../../modules/issue_board"
#
#   target = {
#     type = "project"
#     id   = data.gitlab_project.main_project.id
#   }
#
#   boards = {
#     "Sprint Board" = {
#       labels = ["in-progress", "review", "done"]
#       lists = [
#         { label_id = 12345 },  # Replace with actual label IDs
#         { label_id = 12346 },
#       ]
#     }
#     "Team Alpha" = {
#       assignee_id = 123  # Filter by assignee
#       weight      = 5    # Filter by weight
#     }
#   }
# }

output "project_boards" {
  description = "Created project issue boards"
  value       = module.project_boards.boards
}
