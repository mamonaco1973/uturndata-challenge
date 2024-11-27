# Add key for all EC2 instances that are created

resource "aws_key_pair" "challenge-key" {
  key_name   = "challenge-key"
  public_key = file("./keys/EC2_key_public")
}

