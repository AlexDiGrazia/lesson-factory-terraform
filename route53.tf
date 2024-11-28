resource "aws_route53_zone" "primary" {
  name = "www.lesson-factory.com"
}

data "aws_route53_zone" "primary_data" {
  name         = aws_route53_zone.primary.name
  private_zone = false
  depends_on = [ aws_route53_zone.primary ]
}

resource "aws_route53_record" "lf_record" {
  for_each = {
    for dvo in aws_acm_certificate.lf_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = data.aws_route53_zone.primary_data.zone_id
  depends_on = [ aws_acm_certificate.lf_certificate ]
}