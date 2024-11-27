
# Create the IAM Role for our EC2 instances

resource "aws_iam_role" "challenge_ec2_role" {
  name = "challenge_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Create the Full Access Policy
resource "aws_iam_policy" "challenge_access_policy" {
  name        = "challenge_access_policy"
  description = "Policy that allows full access to all AWS services"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "*",
        Resource = "*"
      }
    ]
  })
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_access_policy" {
  role       = aws_iam_role.challenge_ec2_role.name
  policy_arn = aws_iam_policy.challenge_access_policy.arn
}
