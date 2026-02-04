# Issue Board Module Example

This example demonstrates the `issue-board` module features.

## GitLab Tier Limitations

| Feature | Free | Premium | Ultimate |
|---------|------|---------|----------|
| Single board per project | Yes | Yes | Yes |
| Multiple boards | No | Yes | Yes |
| Board scoping (labels, assignee, milestone, weight) | No | Yes | Yes |
| Lists with label_id | Yes | Yes | Yes |
| Lists with assignee_id, iteration_id, milestone_id | No | Yes | Yes |

## What it tests

**Free tier:**
- Project boards (basic, name only)
- Multiple project boards
- YAML file loading

**Requires Owner role or Premium (commented out):**
- Group boards

**Premium tier (commented out):**
- Board scoping with labels, assignee, milestone, weight
- Custom lists with label_id

## Usage

```bash
export GITLAB_TOKEN="your-token"
tofu init
tofu plan
tofu apply
```

## Prerequisites

- Edit `main.tf` with your group path and project path

## Note

On Free tier, only one board per project is allowed. Creating multiple boards will fail unless you have GitLab Premium.
