resource "aws_lb" "load_balancer" {
  name               = "${var.app_name}-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_security_group.id]
  subnets            = module.vpc.public_subnet_ids
}

resource "aws_lb_target_group" "api" {
  name = "${var.app_name}-api-target-group"
  port = 3000
  protocol = "HTTP"
  vpc_id = module.vpc.vpc_id

  health_check {
    path = "/api"
  }
}

resource "aws_lb_target_group_attachment" "api_attachment" {
  count = 2
  target_group_arn = aws_lb_target_group.api.arn
  target_id = aws_instance.private_ec2[count.index].id
  port = 3000
}

resource "aws_lb_target_group" "frontend" {
  name = "${var.app_name}-frontend-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = module.vpc.vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "frontend_attachment" {
  count = 2
  target_group_arn = aws_lb_target_group.frontend.arn
  target_id = aws_instance.private_ec2[count.index].id
  port = 80
}

resource "aws_lb_listener" "cwc_lb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.cwc_lb_listener.arn
  
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}