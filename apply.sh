#!/bin/bash

# First phase - Build all the infrastructure with 0 autoscaling instances and a generic AMI

cd 01-infrastructure
terraform init
terraform apply -auto-approve
cd ..

# Second phase - Run the packer build to buld the application after we have a network

cd 02-packer
vpc_id=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=challenge-vpc" --query "Vpcs[0].VpcId" --output text)
subnet_id=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=challenge-subnet-1" --query "Subnets[0].SubnetId" --output text)
packer init ./flask_ami.pkr.hcl
packer build -var "vpc_id=$vpc_id" -var "subnet_id=$subnet_id" ./flask_ami.pkr.hcl
ami_id=$(aws ec2 describe-images --filters "Name=name,Values=flask_server_ami*" "Name=state,Values=available" --query "Images | sort_by(@, &CreationDate) | [-1].ImageId" --output text) 
echo $ami_id
cd ..

# Third phase - Re-run infrastructure code with the application AMI and two instances spread across to two AZs

cd 01-infrastructure
terraform apply -var="default_ami=$ami_id" -var="asg_instances=2" -auto-approve


