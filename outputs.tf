output "application_http_url" {
  value = "http://${module.alb.dns_name}"
}

output "ip_set_arn" {
    value = aws_wafv2_ip_set.ip_set.arn
}
