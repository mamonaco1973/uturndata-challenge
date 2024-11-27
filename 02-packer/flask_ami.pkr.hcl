packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
     
    windows-update = {
      source  = "github.com/rgl/windows-update"
      version = "0.15.0"
    }
  }
}

variable "region" {
  default = "us-east-2" 
}

variable "instance_type" {
  default = "t2.micro"
}

variable "source_ami" {
  default = "ami-0c80e2b6ccb9ad6d1"
}

variable "ami_name" {
  default = "flask-server-ami"
}

source "amazon-ebs" "flask_ami" {
  region            = var.region
  instance_type     = var.instance_type
  source_ami        = var.source_ami
  ssh_username      = "ec2-user"
  ami_name          = var.ami_name
  ssh_interface     = "public_ip"
  vpc_id            = "vpc-0aa88929e09c955ed"
  subnet_id         = "subnet-03c39de8f10a86b78"
  security_group_id = "sg-0948f9b7dd828d5ea"
}

build {
  sources = ["source.amazon-ebs.flask_ami"]

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /flask",
      "sudo chmod 777 /flask"
    ]
  }

    provisioner "file" {
    source      = "./scripts/"
    destination = "/flask/"
  }

  provisioner "shell" {
  script = "./install.sh"
  }

}
