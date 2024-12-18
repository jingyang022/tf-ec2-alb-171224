# Creating the IP Set tp be defined in AWS WAF 
resource "aws_wafv2_ip_set" "ip_set" {
  name               = "${local.name_prefix}-ipset"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["218.212.43.33/32"]
}

resource "aws_wafv2_web_acl" "my_web_acl" {
  name        = "${local.name_prefix}-webapp-acl"
  #description = "Example of a managed rule."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "allow-ip"
    priority = 1

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_set.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "web_acl_association_my_lb" {
  resource_arn = module.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.my_web_acl.arn
}

