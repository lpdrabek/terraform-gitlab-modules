module "deploy_tokens" {
  source   = "gitlab.com/gitlab-utl/deploy-token/gitlab"
  version  = ">= 1.0.0, < 2.0.0"
  for_each = local.all_groups

  target = {
    type = "group"
    id   = var.create_only ? gitlab_group.create_only_groups[each.key].id : gitlab_group.groups[each.key].id
  }

  tokens      = each.value.deploy_tokens
  tokens_file = each.value.deploy_tokens_file
  create_only = each.value.deploy_tokens_create_only
}
