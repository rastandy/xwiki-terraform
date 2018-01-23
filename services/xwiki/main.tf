provider "aws" {
  region = "${var.aws_region}"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.service}-remote-state"
    key    = "env:/${terraform.workspace}/vpc/terraform.tfstate"
    region = "${var.aws_region}"
  }
}

module "security_group" {
  source = "github.com/rastandy/terraform-aws-security-group?ref=1.13.0"

  name        = "${var.service}-security-group"
  description = "Security group for ${var.service} usage with EC2 instance"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "http-8080-tcp", "http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

data "aws_ami" "centos_7" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "Centos*-x86_64-*",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "Centos",
    ]
  }
}

module "ec2_cluster" {
  source = "github.com/rastandy/terraform-aws-ec2-instance?ref=v1.2.0"

  name  = "xwiki-instance-${terraform.workspace}"
  count = 1

  ami                    = "ami-7cbc6e13"
  instance_type          = "t2.micro"
  key_name               = "eucp-xwiki"
  monitoring             = true
  vpc_security_group_ids = ["${module.security_group.this_security_group_id}"]
  subnet_id              = "${data.terraform_remote_state.vpc.public_subnets.0}"

  tags = {
    Environment = "${terraform.workspace}"
    Service     = "${var.service}"
  }
}
