# Create EC2 instances for the load balancer

# Create the Instance Profile for the Role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.challenge_ec2_role.name
}

# Create the first AWS instance

resource "aws_instance" "challenge_instance_1" {
  ami           = "ami-0c80e2b6ccb9ad6d1"
  key_name      = "challenge-key"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.challenge-subnet-1.id
  
  # Assign a public IP
  associate_public_ip_address = true

  # Add security groups
  vpc_security_group_ids = [
    aws_security_group.challenge_sg_ssh.id,
    aws_security_group.challenge_sg_flask.id
  ]

  # Attach the Instance Profile
  
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  # Include the user data script
  user_data = file("./scripts/bootstrap.sh")

  tags = {
    Name = "instance-1"
  }
}

resource "aws_lb_target_group_attachment" "challenge_instance_1" {
  target_group_arn = aws_lb_target_group.challenge_alb_tg.arn
  target_id        = aws_instance.challenge_instance_1.id
  port             = 8000
}

# Create the second AWS instance

resource "aws_instance" "challenge_instance_2" {
  ami           = "ami-0c80e2b6ccb9ad6d1"
  key_name      = "challenge-key"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.challenge-subnet-2.id
  
  # Assign a public IP
  associate_public_ip_address = true

  # Add security groups
  vpc_security_group_ids = [
    aws_security_group.challenge_sg_ssh.id,
    aws_security_group.challenge_sg_flask.id
  ]

  # Attach the Instance Profile
  
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  # Include the user data script
  user_data = file("./scripts/bootstrap.sh")

  tags = {
    Name = "instance-2"
  }
}

resource "aws_lb_target_group_attachment" "challenge_instance_2" {
  target_group_arn = aws_lb_target_group.challenge_alb_tg.arn
  target_id        = aws_instance.challenge_instance_2.id
  port             = 8000
}

