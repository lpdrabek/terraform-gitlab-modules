output "project_boards" {
  description = "Map of created project issue boards"
  value       = gitlab_project_issue_board.issue_board
}

output "group_boards" {
  description = "Map of created group issue boards"
  value       = gitlab_group_issue_board.issue_board
}

output "boards" {
  description = "Map of all created boards (project or group depending on target)"
  value       = var.target.type == "project" ? gitlab_project_issue_board.issue_board : gitlab_group_issue_board.issue_board
}
