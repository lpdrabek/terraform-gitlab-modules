resource "gitlab_branch" "project_branch" {
  for_each        = local.all_branches
  name            = each.key
  ref             = each.value.create_from
  project         = var.project
  keep_on_destroy = each.value.keep_on_destroy

  # The ref attribute is only set in state on resource creation.
  # Imports or divergent branches can lead Terraform to destroy
  # and recreate the resource. Use the lifecycle meta-argument
  # to ignore changes to avoid this behavior.
  lifecycle {
    ignore_changes = [ref]
  }
}

