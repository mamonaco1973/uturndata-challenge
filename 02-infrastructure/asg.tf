
# Create Auto Scaling Group

resource "aws_autoscaling_group" "challenge_flask_asg" {
  launch_template {
    id      = aws_launch_template.challenge_launch_template.id
    version = "$Latest"
  }

  name                = "challenge-flask-asg"
  vpc_zone_identifier = [aws_subnet.challenge-subnet-1.id, aws_subnet.challenge-subnet-2.id] 
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  health_check_type   = "ELB"
  health_check_grace_period = 30

  target_group_arns   = [aws_lb_target_group.challenge_alb_tg.arn]

  tag {
    key                 = "Name"
    value               = "challenge-asg-instance"
    propagate_at_launch = true
  }
}