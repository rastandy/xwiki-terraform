provider "aws" {
  region = "eu-central-1"
}

##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "example"
  description = "Security group for example usage with EC2 instance"
  vpc_id      = "${data.aws_vpc.default.id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "http-8080-tcp", "http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

data "aws_ami" "centos_7" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "Centos-7*-x86_64-*",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "centos",
    ]
  }
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "1.1.0"

  name                        = "example"
  ami                         = "${data.aws_ami.centos_7.id}"
  instance_type               = "t2.micro"
  subnet_id                   = "${element(data.aws_subnet_ids.all.ids, 0)}"
  vpc_security_group_ids      = ["${module.security_group.this_security_group_id}"]
  associate_public_ip_address = true

  user_data = <<-EOF
               #!/bin/bash
               echo "Hello, World" > index.html
               nohup busybox httpd -f -p 8080 &
              EOF
}
