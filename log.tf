# {namespace}-{stage}-{region}-vpc-flow-role
resource "aws_iam_role" "flow" {
  name = format("%s-vpc-flow-log-role", local.prefix_hyphen)
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "",
        Effect : "Allow",
        Principal : {
          Service : "vpc-flow-logs.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })

  tags = merge({
    Name              = format("%s-vpc-flow-log-role", local.prefix_hyphen)
    RESOURCE_CATEGORY = "IAM"
  }, local.tags)
}

# {namespace}-{stage}-{region}-vpc-flow-policy
resource "aws_iam_role_policy" "flow" {
  name = format("%s-vpc-flow-log-policy", local.prefix_hyphen)
  role = aws_iam_role.flow.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Resource : "*"
      }
    ]
  })
}

# /audit/vpc/{namespace}-{stage}-{region}-vpc-flow-log
resource "aws_cloudwatch_log_group" "flow" {
  name              = format("/audit/vpc/%s-vpc-flow-log", local.prefix_hyphen)
  retention_in_days = 365
  tags = merge({
    Name              = format("/audit/vpc/%s-vpc-flow-log", local.prefix_hyphen)
    RESOURCE_CATEGORY = "AUDIT"
  }, local.tags)
}
