# Creating the IP Set tp be defined in AWS WAF 
resource "aws_wafv2_ip_set" "ip_set" {
  name               = "${local.name_prefix}-ipset"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["218.212.36.47/32"]
}

resource "aws_wafv2_web_acl" "my_web_acl" {
  name        = "${local.name_prefix}-webapp-acl"
  #description = "Example of a managed rule."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule{
    name     = "block-admin-path"
    priority = 1

    action {
      block {}
    }

    statement {
      byte_match_statement {
        positional_constraint = "CONTAINS"
        search_string         = "admin"
        field_to_match {
          uri_path {}
          }
        text_transformation {
          priority = 0
          type     = "NONE"
          }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "block-admin-path"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "allow-ip"
    priority = 2

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
    metric_name                = "allow-ip"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "web_acl_association_my_lb" {
  resource_arn = module.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.my_web_acl.arn
}

