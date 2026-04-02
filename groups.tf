resource "aws_iam_group" "education" {
    name = "Education"
    path = "/groups/"
  
}
resource "aws_iam_group" "managers" {
  name = "Managers"
  path = "/groups/"
}

resource "aws_iam_group" "engineers" {
  name = "Engineers"
  path = "/groups/"
}
resource "aws_iam_group_membership" "education_members"{
    name = "education-group-membership"
    group = aws_iam_group.education.name 

    users = [
        for user in aws_iam_user.users : user.name if user.tags.Department == "Education"
    ]
}
resource "aws_iam_group_membership" "managers_members" {
  name  = "managers-group-membership"
  group = aws_iam_group.managers.name


  users = [
    for user in aws_iam_user.users : user.name if contains(keys(user.tags), "JobTitle") && can(regex("Manager|CEO", user.tags.JobTitle))
  ]
}

# Add users to the Engineers group
resource "aws_iam_group_membership" "engineers_members" {
  name  = "engineers-group-membership"
  group = aws_iam_group.engineers.name

  users = [
    for user in aws_iam_user.users : user.name if user.tags.Department == "Engineering" # Note: No users match this in the current CSV
  ]
}
resource "aws_iam_policy" "shared_policy" {
  name = "shared-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["iam:AttachGroupPolicy"]
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_group_policy_attachment" "attach_policy" {
  for_each = {
    managers  = aws_iam_group.managers.name
    education = aws_iam_group.education.name
    engineers = aws_iam_group.engineers.name
  }

  group      = each.value
  policy_arn = aws_iam_policy.shared_policy.arn
}

