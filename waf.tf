# Creating the IP Set tp be defined in AWS WAF 
resource "aws_wafv2_ip_set" "ip_set" {
  name               = "${local.name_prefix}-ipset"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["218.212.43.33/32"]
}