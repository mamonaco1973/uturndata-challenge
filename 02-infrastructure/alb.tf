
# Create application load balancer 

resource "aws_lb" "challenge_alb" {
  name               = "challenge-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.challenge_sg_http.id]
  subnets            = [aws_subnet.challenge-subnet-1.id, aws_subnet.challenge-subnet-2.id] 
}

resource "aws_lb_target_group" "challenge_alb_tg" {
  name        = "challenge-alb-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.challenge-vpc.id

  health_check {
    path                = "/"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200,300-310"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.challenge_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.challenge_alb_tg.arn
  }
}
