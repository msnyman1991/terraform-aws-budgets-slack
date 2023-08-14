resource "aws_sns_topic" "aws_budget_alerts" {
  name = "${var.aws_account_id}-aws-budget-alerts"
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.aws_budget_alerts.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "aws_budget_alerts_target" {
  topic_arn = aws_sns_topic.aws_budget_alerts.arn
  protocol  = "email"
  endpoint  = var.email_address
}

resource "aws_budgets_budget" "monthly" {
  name         = "budget-monthly"
  budget_type  = "COST"
  limit_amount = var.limit_amount
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = var.threshold
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.aws_budget_alerts.arn]
  }
}

resource "aws_iam_policy" "chatbot_role_policy" {
  name   = "chatbot-policy"
  policy = data.aws_iam_policy_document.chatbot_policy.json
}

resource "aws_iam_role" "chatbot_role" {
  name               = "chatbot-role"
  assume_role_policy = data.aws_iam_policy_document.aws_budgets_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "chatbot_policy_attach" {
  role       = aws_iam_role.chatbot_role.name
  policy_arn = aws_iam_policy.chatbot_role_policy.arn
}

resource "awscc_chatbot_slack_channel_configuration" "aws_budget_alerts_slack" {
  configuration_name = "slack_aws_budget_alerts"
  iam_role_arn       = aws_iam_role.chatbot_role.arn
  slack_channel_id   = var.slack_channel_id
  slack_workspace_id = var.slack_workspace_id
  sns_topic_arns     = [aws_sns_topic.aws_budget_alerts.arn]
  logging_level      = "ERROR"
}
