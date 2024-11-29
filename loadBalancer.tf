resource "aws_lb" "load_balancer" {
  name               = "${var.app_name}-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_security_group.id]
  subnets            = aws_subnet.public_subnet[*].id
}

resource "aws_lb_target_group" "api" {
  name = "lesson-factory-api-target-group"
  port = 3000
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
}


resource "aws_lb_target_group_attachment" "api_attachment" {
  count = 2
  target_group_arn = aws_lb_target_group.api.arn
  target_id = aws_instance.private_ec2[count.index].id
  port = 3000
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = "80"
  protocol = "HTTP"

  default_action { 
    type = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

resource "aws_lb_listener" "lb_listener_https" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  # certificate_arn = aws_acm_certificate_validation.acm_cert_validation.certificate_arn
  certificate_arn = var.acm_arn

  default_action { 
    type = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}