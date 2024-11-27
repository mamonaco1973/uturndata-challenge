
# Create security group for all SSH traffic

resource "aws_security_group" "challenge_sg_ssh" {
  name        = "challenge-sg-ssh"
  description = "Security group to allow SSH access and open all outbound traffic"
  vpc_id      = aws_vpc.challenge-vpc.id

  # Ingress rule to allow SSH (port 22) from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "challenge-sg-ssh"
  }
}

# Create security group for all HTTP traffic

resource "aws_security_group" "challenge_sg_http" {
  name        = "challenge-sg-http"
  description = "Security group to allow port 80 access and open all outbound traffic"
  vpc_id      = aws_vpc.challenge-vpc.id
  
  # Ingress rule to allow SSH (port 22) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "challenge-sg-http"
  }
}

# Create security group for all Flask traffic

resource "aws_security_group" "challenge_sg_flask" {
  name        = "challenge-sg-flask"
  description = "Security group to allow port 8000 flask access and open all outbound traffic"
  vpc_id      = aws_vpc.challenge-vpc.id

  # Ingress rule to allow SSH (port 22) from anywhere
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "challenge-sg-flask"
  }
}
