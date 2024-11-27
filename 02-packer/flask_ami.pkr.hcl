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

data "amazon-ami" "linux-base-os-image" {
  filters = {
    name                = "al2023-ami-2023*x86_64"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["amazon"]
}

variable "region" {
  default = "us-east-2" 
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_id" {
  description = "The ID of the VPC to use"
  default     = ""  # Replace with your actual VPC ID
}

variable "subnet_id" {
  description = "The ID of the subnet to use"
  default     = ""  # Replace with your actual subnet id
}

source "amazon-ebs" "flask_ami" {
  region            = var.region
  instance_type     = var.instance_type
  source_ami       = "${data.amazon-ami.linux-base-os-image.id}"
  ssh_username      = "ec2-user"
  ami_name          = "flask_server_ami_${replace(timestamp(), ":", "-")}"
  ssh_interface     = "public_ip"
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
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
