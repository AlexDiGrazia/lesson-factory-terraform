resource "aws_acm_certificate" "lf_certificate" {
  domain_name       = "www.lesson-factory.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "acm_cert_validation" {
  certificate_arn         = aws_acm_certificate.lf_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.lf_record : record.fqdn]
  depends_on = [ aws_acm_certificate.lf_certificate ]
}