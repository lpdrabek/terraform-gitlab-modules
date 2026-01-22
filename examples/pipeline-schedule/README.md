# Pipeline Schedule Module Example

This example demonstrates all features of the `pipeline-schedule` module.

## What it tests

- **Basic schedules** - Pipeline schedules with cron expressions
- **Schedule variables** - Variables passed to scheduled pipelines
- **Timezones** - Schedules with custom timezones
- **Active/inactive** - Enabling and disabling schedules
- **Take ownership** - Ensuring Terraform can manage schedule variables
- **YAML file loading** - Schedules loaded from `schedules.yml`
- **Variable types** - Both `env_var` and `file` type variables

## Usage

```bash
export TF_VAR_gitlab_token="your-token"
tofu init
tofu plan
tofu apply
```

## Prerequisites

- Edit `main.tf` with your project path
- Ensure the target branch exists in the project (e.g., `refs/heads/master`)
- Ensure the project has a valid `.gitlab-ci.yml` file

## Important Notes

### Pipeline Variables

GitLab 18.1+ may have pipeline variables disabled by default in favor of pipeline inputs. If you receive 403 errors when creating schedule variables:

1. Go to your project: Settings > CI/CD > Variables
2. Check the "Minimum role to use pipeline variables" setting
3. Ensure pipeline variables are enabled for your role

### Branch References

The `ref` field must be the full branch reference:
- Correct: `refs/heads/main`, `refs/heads/master`
- Incorrect: `main`, `master`

The branch must exist in the repository for the schedule to work.
