
# Create Auto Scaling Group

# Use the try function to default to a specific AMI if "flask-server-ami" doesn't exist
variable "asg_instances" {
  default = 0
}


# Create CloudWatch Alarm for scaling up when CPUUtilization > 80%
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Scale up if CPUUtilization > 80% for 2 minutes"
  actions_enabled     = true

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.challenge_flask_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up_policy.arn]
}

# Scaling policy for scaling up
resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 120
  autoscaling_group_name = aws_autoscaling_group.challenge_flask_asg.name
}

# Create CloudWatch Alarm for scaling down when CPUUtilization < 5%
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "LowCPUUtilization"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 5
  alarm_description   = "Scale down if CPUUtilization < 5% for 2 minutes"
  actions_enabled     = true

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.challenge_flask_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down_policy.arn]
}

# Scaling policy for scaling down
resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 120
  autoscaling_group_name = aws_autoscaling_group.challenge_flask_asg.name
}

resource "aws_autoscaling_group" "challenge_flask_asg" {
  launch_template {
    id      = aws_launch_template.challenge_launch_template.id
    version = "$Latest"
  }

  name                      = "challenge-flask-asg"
  vpc_zone_identifier       = [aws_subnet.challenge-subnet-1.id, aws_subnet.challenge-subnet-2.id]
  desired_capacity          = var.asg_instances
  max_size                  = 4
  min_size                  = var.asg_instances
  health_check_type         = "ELB"
  health_check_grace_period = 30
  default_cooldown          = 30
  default_instance_warmup   = 60

  target_group_arns = [aws_lb_target_group.challenge_alb_tg.arn]

  tag {
    key                 = "Name"
    value               = "challenge-asg-instance"
    propagate_at_launch = true
  }
}
