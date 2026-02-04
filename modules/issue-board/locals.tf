locals {
  yaml_content = try(yamldecode(file(var.boards_file)), {})

  boards_from_file = {
    for name, board in local.yaml_content :
    name => {
      labels       = try(board.labels, null)
      assignee_id  = try(board.assignee_id, null)
      milestone_id = try(board.milestone_id, null)
      weight       = try(board.weight, null)
      lists = try(board.lists != null ? [
        for l in board.lists : {
          assignee_id  = try(l.assignee_id, null)
          iteration_id = try(l.iteration_id, null)
          label_id     = try(l.label_id, null)
          milestone_id = try(l.milestone_id, null)
          position     = try(l.position, null)
        }
      ] : null, null)
    }
  }

  all_boards = merge(var.boards, local.boards_from_file)
}
