
resource "aws_cloudwatch_log_group" "query_logs" {
  name = "/aws/route53/${var.route53_zone_name}"
  retention_in_days = 30
}
data "aws_iam_policy_document" "route53-query-logging-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      
    ]
    resources = ["arn:aws:logs:*:*:log-group:/aws/route53/*"]
    principals {
      identifiers = ["route53.amazonaws.com"]
      type = "Service"
    }
  }
}
resource "aws_cloudwatch_log_resource_policy" "route53-query-logging-policy" {
  policy_document = data.aws_iam_policy_document.route53-query-logging-policy.json
  policy_name = "route53-query-logging-policy"
}


resource "aws_route53_query_log" "check_com" {
  depends_on = [aws_cloudwatch_log_resource_policy.route53-query-logging-policy]
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.query_logs.arn
  zone_id = var.zone_id
  
}
