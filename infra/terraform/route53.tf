data "aws_lb" "existing" {
  name = var.existing_alb_name
}

resource "aws_route53_record" "app_alias" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = data.aws_lb.existing.dns_name
    zone_id                = data.aws_lb.existing.zone_id
    evaluate_target_health = true
  }
}
