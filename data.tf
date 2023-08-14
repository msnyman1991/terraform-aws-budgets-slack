data "aws_iam_policy_document" "aws_budgets_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com", "budgets.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "chatbot_policy" {
  statement {
    actions = [
      "sns:ListTagsForResource",
      "sns:ListSubscriptionsByTopic",
      "sns:GetTopicAttributes",
      "sns:ListSMSSandboxPhoneNumbers",
      "sns:ListTopics",
      "sns:GetPlatformApplicationAttributes",
      "sns:GetSubscriptionAttributes",
      "sns:ListSubscriptions",
      "sns:CheckIfPhoneNumberIsOptedOut",
      "sns:GetDataProtectionPolicy",
      "sns:ListOriginationNumbers",
      "sns:ListPhoneNumbersOptedOut",
      "sns:ListEndpointsByPlatformApplication",
      "sns:GetEndpointAttributes",
      "sns:Publish",
      "sns:GetSMSSandboxAccountStatus",
      "sns:Subscribe",
      "sns:ConfirmSubscription",
      "sns:GetSMSAttributes",
      "sns:ListPlatformApplications"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    actions = [
      "sns:Publish"
    ]

    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.aws_budget_alerts.arn
    ]

  }
}
